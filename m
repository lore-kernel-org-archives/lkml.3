Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422855AbaDKA0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:26:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:50662 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbaDKA03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,837,1389772800"; 
   d="scan'208";a="511222932"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Paul McQuade <paulmcquad@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "al.stone@linaro.org" <al.stone@linaro.org>,
        "naresh.bhat@linaro.org" <naresh.bhat@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH] include: replace asm headers to linux
Thread-Topic: [PATCH] include: replace asm headers to linux
Thread-Index: AQHPVRSWfVn0R8/1M0qSLhp9kCBmNZsLjDCQ
Date: Fri, 11 Apr 2014 00:26:23 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88025521F4@SHSMSX101.ccr.corp.intel.com>
References: <1397172486-13214-1-git-send-email-paulmcquad@gmail.com>
In-Reply-To: <1397172486-13214-1-git-send-email-paulmcquad@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Paul McQuade
> Sent: Friday, April 11, 2014 7:28 AM
> 
> Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
> Use #include <linux/types.h> instead of <asm/types.h>
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  include/acpi/platform/aclinux.h           | 2 +-
>  include/asm-generic/bitops/__ffs.h        | 2 +-
>  include/asm-generic/bitops/__fls.h        | 2 +-
>  include/asm-generic/bitops/arch_hweight.h | 2 +-
>  include/asm-generic/bitops/atomic.h       | 6 +++---
>  include/asm-generic/bitops/count_zeros.h  | 2 +-
>  include/asm-generic/bitops/fls64.h        | 2 +-
>  include/asm-generic/bitops/le.h           | 2 +-
>  include/asm-generic/bitops/non-atomic.h   | 2 +-
>  include/asm-generic/bitops/sched.h        | 2 +-
>  10 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index 93c55ed..d52317f 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -71,7 +71,7 @@
>  #ifdef EXPORT_ACPI_INTERFACES
>  #include <linux/export.h>
>  #endif
> -#include <asm/acpi.h>
> +#include <linux/acpi.h>
> 
>  /* Host-dependent types and defines for in-kernel ACPICA */
> 

This diff block is wrong.

The acpi/platform/aclinux.h is a "platform specific ACPICA environment header".
The linux/acpi.h is a "Top level header of Linux ACPI".
The asm/acpi.h is a combination of " architecture specific ACPICA environment header" and "architecture specific Linux ACPI header".

The relationship between Linux ACPI and ACPICA is:
Linux ACPI is using ACPICA.
So linux ACPI header should __INCLUDE__ ACPICA header, which means linux/acpi.h should include acpi/platform/aclinux.h.
You patch thus is wrong.

In fact, acpi/platform/aclinux.h is included by acpi/acpi.h and acpi/acpi.h is included by linux/acpi.h.

For asm/acpi.h, there are really things messed up in it.
I have a series to split its role so that wrong "architecture specific Linux ACPI header" can be sorted out from acpi/platform/aclinux.h.
Please refer to:
https://lkml.org/lkml/2014/4/8/57

The correct way to fix the issue you are trying to fix is this patch:
https://lkml.org/lkml/2014/4/8/60

So please drop this diff block and just wait for the above mentioned series to be merged.

Thanks and best regards
-Lv

> diff --git a/include/asm-generic/bitops/__ffs.h b/include/asm-generic/bitops/__ffs.h
> index 937d7c4..8236f91 100644
> --- a/include/asm-generic/bitops/__ffs.h
> +++ b/include/asm-generic/bitops/__ffs.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS___FFS_H_
>  #define _ASM_GENERIC_BITOPS___FFS_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  /**
>   * __ffs - find first bit in word.
> diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
> index a60a7cc..60e5360 100644
> --- a/include/asm-generic/bitops/__fls.h
> +++ b/include/asm-generic/bitops/__fls.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS___FLS_H_
>  #define _ASM_GENERIC_BITOPS___FLS_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  /**
>   * __fls - find last (most-significant) set bit in a long word
> diff --git a/include/asm-generic/bitops/arch_hweight.h b/include/asm-generic/bitops/arch_hweight.h
> index 6a211f4..a9a48a8 100644
> --- a/include/asm-generic/bitops/arch_hweight.h
> +++ b/include/asm-generic/bitops/arch_hweight.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
>  #define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  static inline unsigned int __arch_hweight32(unsigned int w)
>  {
> diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
> index 9ae6c34..4469696 100644
> --- a/include/asm-generic/bitops/atomic.h
> +++ b/include/asm-generic/bitops/atomic.h
> @@ -1,12 +1,12 @@
>  #ifndef _ASM_GENERIC_BITOPS_ATOMIC_H_
>  #define _ASM_GENERIC_BITOPS_ATOMIC_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
>  #include <linux/irqflags.h>
> 
>  #ifdef CONFIG_SMP
> -#include <asm/spinlock.h>
> -#include <asm/cache.h>		/* we use L1_CACHE_BYTES */
> +#include <linux/spinlock.h>
> +#include <linux/cache.h>		/* we use L1_CACHE_BYTES */
> 
>  /* Use an array of spinlocks for our atomic_ts.
>   * Hash function to index into a different SPINLOCK.
> diff --git a/include/asm-generic/bitops/count_zeros.h b/include/asm-generic/bitops/count_zeros.h
> index 97520d2..7f8e1d0 100644
> --- a/include/asm-generic/bitops/count_zeros.h
> +++ b/include/asm-generic/bitops/count_zeros.h
> @@ -12,7 +12,7 @@
>  #ifndef _ASM_GENERIC_BITOPS_COUNT_ZEROS_H_
>  #define _ASM_GENERIC_BITOPS_COUNT_ZEROS_H_
> 
> -#include <asm/bitops.h>
> +#include <linux/bitops.h>
> 
>  /**
>   * count_leading_zeros - Count the number of zeros from the MSB back
> diff --git a/include/asm-generic/bitops/fls64.h b/include/asm-generic/bitops/fls64.h
> index b097cf8..3999f5c 100644
> --- a/include/asm-generic/bitops/fls64.h
> +++ b/include/asm-generic/bitops/fls64.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS_FLS64_H_
>  #define _ASM_GENERIC_BITOPS_FLS64_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  /**
>   * fls64 - find last set bit in a 64-bit word
> diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
> index 6173154..8f4f574 100644
> --- a/include/asm-generic/bitops/le.h
> +++ b/include/asm-generic/bitops/le.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS_LE_H_
>  #define _ASM_GENERIC_BITOPS_LE_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
>  #include <asm/byteorder.h>
> 
>  #if defined(__LITTLE_ENDIAN)
> diff --git a/include/asm-generic/bitops/non-atomic.h b/include/asm-generic/bitops/non-atomic.h
> index 697cc2b..4b04267 100644
> --- a/include/asm-generic/bitops/non-atomic.h
> +++ b/include/asm-generic/bitops/non-atomic.h
> @@ -1,7 +1,7 @@
>  #ifndef _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
>  #define _ASM_GENERIC_BITOPS_NON_ATOMIC_H_
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  /**
>   * __set_bit - Set a bit in memory
> diff --git a/include/asm-generic/bitops/sched.h b/include/asm-generic/bitops/sched.h
> index 604fab7..65ad856 100644
> --- a/include/asm-generic/bitops/sched.h
> +++ b/include/asm-generic/bitops/sched.h
> @@ -2,7 +2,7 @@
>  #define _ASM_GENERIC_BITOPS_SCHED_H_
> 
>  #include <linux/compiler.h>	/* unlikely() */
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
>  /*
>   * Every architecture must define this function. It's the fastest
> --
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

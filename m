Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3A2RFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:05:53 -0500
Received: from multi.imgtec.com ([194.200.65.239]:1163 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab3A2RFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:05:51 -0500
Message-ID: <5108016B.5050303@imgtec.com>
Date: Tue, 29 Jan 2013 17:05:47 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Robert Richter <rric@kernel.org>,
        <oprofile-list@lists.sf.net>
Subject: Re: [PATCH v3 40/71] ARC: OProfile support
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com> <1359025589-22277-25-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1359025589-22277-25-git-send-email-vgupta@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_29_17_05_49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On 24/01/13 11:06, Vineet Gupta wrote:
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: Robert Richter <rric@kernel.org>
> Cc: oprofile-list@lists.sf.net
> ---
>  arch/arc/Kconfig           |    1 +
>  arch/arc/Makefile          |    2 ++
>  arch/arc/oprofile/Makefile |    9 +++++++++
>  arch/arc/oprofile/common.c |   22 ++++++++++++++++++++++
>  4 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arc/oprofile/Makefile
>  create mode 100644 arch/arc/oprofile/common.c
> 
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 409b937..405ea7a 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -25,6 +25,7 @@ config ARC
>  	select HAVE_ARCH_TRACEHOOK
>  	select HAVE_GENERIC_HARDIRQS
>  	select HAVE_MEMBLOCK
> +	select HAVE_OPROFILE
>  	select IRQ_DOMAIN
>  	select MODULES_USE_ELF_RELA
>  	select NO_BOOTMEM
> diff --git a/arch/arc/Makefile b/arch/arc/Makefile
> index 4247f48..4f28f5b 100644
> --- a/arch/arc/Makefile
> +++ b/arch/arc/Makefile
> @@ -100,6 +100,8 @@ ifneq ($(platform-y),)
>  core-y		+= arch/arc/plat-$(PLATFORM)/
>  endif
>  
> +drivers-$(CONFIG_OPROFILE)	+= arch/arc/oprofile/
> +
>  libs-y		+= arch/arc/lib/ $(LIBGCC)
>  
>  #default target for make without any arguements.
> diff --git a/arch/arc/oprofile/Makefile b/arch/arc/oprofile/Makefile
> new file mode 100644
> index 0000000..ce417a6
> --- /dev/null
> +++ b/arch/arc/oprofile/Makefile
> @@ -0,0 +1,9 @@
> +obj-$(CONFIG_OPROFILE) += oprofile.o
> +
> +DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
> +		oprof.o cpu_buffer.o buffer_sync.o \
> +		event_buffer.o oprofile_files.o \
> +		oprofilefs.o oprofile_stats.o \
> +		timer_int.o )
> +
> +oprofile-y	:= $(DRIVER_OBJS) common.o
> diff --git a/arch/arc/oprofile/common.c b/arch/arc/oprofile/common.c
> new file mode 100644
> index 0000000..917ae16
> --- /dev/null
> +++ b/arch/arc/oprofile/common.c
> @@ -0,0 +1,22 @@
> +/*
> + * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Based on orig code from @author John Levon <levon@movementarian.org>
> + */
> +
> +#include <linux/oprofile.h>
> +#include <linux/perf_event.h>
> +
> +int __init oprofile_arch_init(struct oprofile_operations *ops)
> +{
> +	return oprofile_perf_init(ops);

You don't appear to define CONFIG_HW_PERF_EVENTS, so
include/linux/oprofile.h will presumably define oprofile_perf_init as
just a pr_info(...); return -ENODEV;

Similarly drivers/oprofile/oprofile_perf.o doesn't seem to be being built.

I'm probably missing something somewhere?

Cheers
James

> +}
> +
> +void oprofile_arch_exit(void)
> +{
> +	oprofile_perf_exit();
> +}
> 


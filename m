Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3F1QHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:07:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19073 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab3F1QH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:07:28 -0400
Date: Fri, 28 Jun 2013 12:07:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <benjamin.guthro@citrix.com>
Cc: Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        xen-devel@lists.xen.org, Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH v5 1/5] acpi: Remove need to include linux/acpi.h in
 common acpica code
Message-ID: <20130628160710.GF13468@phenom.dumpdata.com>
References: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com>
 <1372427184-6197-2-git-send-email-benjamin.guthro@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372427184-6197-2-git-send-email-benjamin.guthro@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 09:46:20AM -0400, Ben Guthro wrote:
> Move the definition of acpi_os_prepare_sleep into the OS services layer header,
> and remove the include of linux/acpi.h from common acpica code.
> 

Thank you.

> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Bob Moore <robert.moore@intel.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/acpi/acpica/hwsleep.c |    1 -
>  include/acpi/acpiosxf.h       |    6 ++++++
>  include/linux/acpi.h          |    3 ---
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
> index e3828cc..867b947 100644
> --- a/drivers/acpi/acpica/hwsleep.c
> +++ b/drivers/acpi/acpica/hwsleep.c
> @@ -43,7 +43,6 @@
>   */
>  
>  #include <acpi/acpi.h>
> -#include <linux/acpi.h>
>  #include "accommon.h"
>  
>  #define _COMPONENT          ACPI_HARDWARE
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 5b3d2bd..c68b779 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -276,4 +276,10 @@ char *acpi_os_get_next_filename(void *dir_handle);
>  
>  void acpi_os_close_directory(void *dir_handle);
>  
> +/*
> + * ACPI sleep preparation
> + */
> +acpi_status acpi_os_prepare_sleep(u8 sleep_state,
> +				  u32 pm1a_control, u32 pm1b_control);
> +
>  #endif				/* __ACPIOSXF_H__ */
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 17b5b59..709a2f2 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -479,9 +479,6 @@ static inline bool acpi_driver_match_device(struct device *dev,
>  #ifdef CONFIG_ACPI
>  void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>  			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
> -
> -acpi_status acpi_os_prepare_sleep(u8 sleep_state,
> -				  u32 pm1a_control, u32 pm1b_control);
>  #ifdef CONFIG_X86
>  void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>  #else
> -- 
> 1.7.9.5
> 

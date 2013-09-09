Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3IIPUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:20:07 -0400
Received: from crc-server1.constructionresults.com ([76.164.1.27]:57371 "EHLO
	crc-server1.constructionresults.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab3IIPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:20:06 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2013 11:20:05 EDT
Date: Mon, 9 Sep 2013 10:06:34 -0500
From: Robin Holt <robinmholt@linux.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: mingo@kernel.org, holt@sgi.com, hpa@zytor.com, rmk+kernel@arm.linux.org.uk,
        rja@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        fei.li@intel.com
Subject: Re: [PATCH] reboot: re-enable the function of variable reboot_default
Message-ID: <20130909150616.GB28780@julie.rmholt.homeip.net>
References: <1378727380.26153.8.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378727380.26153.8.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 07:49:40PM +0800, Chuansheng Liu wrote:
> 
> commit b3a5d02ee070c(reboot: move arch/x86 reboot= handling to generic kernel)

The commit id was really 1b3a5d02ee070c

> did some cleanup for reboot= command line, but it made the reboot_default
> to be invalidated.
> 
> The default value of variable reboot_default should be 1, and if command line
> reboot= is not set, system will use the default reboot mode.
> 
> Signed-off-by: Li Fei <fei.li@intel.com>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Acked-by: Robin Holt <robinmholt@linux.com>

Thank you for fixing my bug.

Note: My email address used to be holt@sgi.com

> ---
>  kernel/reboot.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/reboot.c b/kernel/reboot.c
> index 269ed93..d82eb6e 100644
> --- a/kernel/reboot.c
> +++ b/kernel/reboot.c
> @@ -32,7 +32,14 @@ EXPORT_SYMBOL(cad_pid);
>  #endif
>  enum reboot_mode reboot_mode DEFAULT_REBOOT_MODE;
>  
> -int reboot_default;
> +/*
> + * This variable is used privately to keep track of whether or not
> + * reboot_type is still set to its default value (i.e., reboot= hasn't
> + * been set on the command line).  This is needed so that we can
> + * suppress DMI scanning for reboot quirks.  Without it, it's
> + * impossible to override a faulty reboot quirk without recompiling.
> +*/
> +int reboot_default = 1;
>  int reboot_cpu;
>  enum reboot_type reboot_type = BOOT_ACPI;
>  int reboot_force;
> -- 
> 1.7.0.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

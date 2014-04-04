Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaDDOMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbaDDOM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:12:27 -0400
Date: Fri, 4 Apr 2014 10:12:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, hpa@zytor.com,
        "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/platform/hyperv: When on Hyper-v use NULL legacy
 PIC
Message-ID: <20140404141218.GA2161@redhat.com>
References: <1396574193-12043-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396574193-12043-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 06:16:33PM -0700, K. Y. Srinivasan wrote:
> Use the NULL legacy PIC when on Hyper-V. With this change we can support kexec
> even when booting on EFI firmware. This patch has been tested on both EFI as
> well as non-EFI firmware stacks on Hyper-V.
> 
> This patch is required to support kexec on EFI firmware on Hyper-V. Please
> apply.

Can you give some more details about what's the problem we run into with
kexec on EFI on hyper-V.

Now EFI should be enabled in kexeced kernel. That means
efi_enabled(EFI_BOOT) should be true and that means you would set
legacy_pic to null anyway.

So with this patch, what changed w.r.t kexec on EFI.

Thansk
Vivek

> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>        [3.13+]
> ---
>  arch/x86/kernel/cpu/mshyperv.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
> index 76f98fe..47359f7 100644
> --- a/arch/x86/kernel/cpu/mshyperv.c
> +++ b/arch/x86/kernel/cpu/mshyperv.c
> @@ -133,14 +133,8 @@ static void __init ms_hyperv_init_platform(void)
>  		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
>  				lapic_timer_frequency);
>  
> -		/*
> -		 * On Hyper-V, when we are booting off an EFI firmware stack,
> -		 * we do not have many legacy devices including PIC, PIT etc.
> -		 */
> -		if (efi_enabled(EFI_BOOT)) {
> -			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> -			legacy_pic = &null_legacy_pic;
> -		}
> +		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
> +		legacy_pic = &null_legacy_pic;
>  	}
>  #endif
>  
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

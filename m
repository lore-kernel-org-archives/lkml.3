Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbaFROI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:08:28 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:62512 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFROIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:08:25 -0400
Date: Wed, 18 Jun 2014 15:08:21 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
Message-ID: <20140618140821.GK24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun, at 07:00:23PM, Daniel Kiper wrote:
> efi_set_rtc_mmss() is never used to set RTC due to bugs found
> on many EFI platforms. It is set directly by mach_set_rtc_mmss().
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/platform/efi/efi.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index deb4f05..bd3e080 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -244,6 +244,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>  	return status;
>  }
>  
> +#if 0
> +/*
> + * efi_set_rtc_mmss() is never used to set RTC due to bugs found
> + * on many EFI platforms. It is set directly by mach_set_rtc_mmss().
> + */
>  int efi_set_rtc_mmss(const struct timespec *now)
>  {
>  	unsigned long nowtime = now->tv_sec;
> @@ -279,6 +284,7 @@ int efi_set_rtc_mmss(const struct timespec *now)
>  	}
>  	return 0;
>  }
> +#endif
>  
>  void efi_get_time(struct timespec *now)
>  {

As others have said in this thread - just delete this sucker.

I did make an attempt to get rid of all the time functions recently, but
chickened out at the last minute because we were nearing the merge
window,

  http://article.gmane.org/gmane.linux.kernel.janitors/30082

So yes, please go ahead and delete this function.

-- 
Matt Fleming, Intel Open Source Technology Center

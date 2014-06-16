Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaFPLnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:43:53 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10934 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaFPLnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:43:50 -0400
X-IronPort-AV: E=Sophos;i="5.01,486,1400025600"; 
   d="scan'208";a="144025855"
Date: Mon, 16 Jun 2014 12:43:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>, <eshelton@pobox.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <stefano.stabellini@eu.citrix.com>,
        <tglx@linutronix.de>
Subject: Re: [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
In-Reply-To: <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
Message-ID: <alpine.DEB.2.02.1406161242050.13771@kaball.uk.xensource.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Daniel Kiper wrote:
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

"Commenting out" code like that is not a good idea: it leaves
dead-rotting functions in the middle of your source file.

If the function is not used, just go ahead and remove it. We can use git
to get it back.

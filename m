Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3LEMD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:03:28 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:57214 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656Ab3LEMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:03:26 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 3/3] init: efi: arm: enable (U)EFI runtime services on arm
To: Leif Lindholm <leif.lindholm@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Cc: matt.fleming@intel.com, roy.franz@linaro.org, msalter@redhat.com,
        patches@linaro.org, linaro-uefi@linaro.org, mark.rutland@arm.com,
        Leif Lindholm <leif.lindholm@linaro.org>
In-Reply-To: <1385656883-4420-4-git-send-email-leif.lindholm@linaro.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> < 1385656883-4420-4-git-send-email-leif.lindholm@linaro.org>
Date: Thu, 05 Dec 2013 12:03:22 +0000
Message-Id: <20131205120322.3479CC407BC@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013 16:41:23 +0000, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> Since the efi_set_virtual_address_map call has strict init ordering
> requirements, add an explicit hook in the required place.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  init/main.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/init/main.c b/init/main.c
> index febc511..1331829 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -905,6 +905,10 @@ static noinline void __init kernel_init_freeable(void)
>  	smp_prepare_cpus(setup_max_cpus);
>  
>  	do_pre_smp_initcalls();
> +
> +	if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
> +		efi_enter_virtual_mode();
> +

Personally, I would put the IS_ENABLED() and efi_enabled() tests into
efi_enter_virtual_mode() itself (or an empty stub for the !IS_ENABLED()
case), but that is mostly a nit.

Acked-by: Grant Likely <grant.likely@linaro.org>

>  	lockup_detector_init();
>  
>  	smp_init();
> -- 
> 1.7.10.4
> 


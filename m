Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3BTXsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 18:48:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35439 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3BTXsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:48:16 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51256042.5030704@jp.fujitsu.com>
Date: Thu, 21 Feb 2013 08:46:10 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Make "noefi" really disable EFI runtime serivces
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

(2013/02/21 5:36), Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> commit 1de63d60cd5b ("efi: Clear EFI_RUNTIME_SERVICES rather than
> EFI_BOOT by "noefi" boot parameter") attempted to make "noefi" true to
> its documentation and disable EFI runtime services to prevent the
> bricking bug described in commit e0094244e41c ("samsung-laptop:
> Disable on EFI hardware"). However, it's not possible to clear
> EFI_RUNTIME_SERVICES from an early param function because
> EFI_RUNTIME_SERVICES is set in efi_init() *after* parse_early_param().
> 
> This resulted in "noefi" effectively becoming a no-op and no longer
> providing users with a way to disable EFI, which is bad for those
> users that have buggy machines.

Sorry, my patch was imperfect. This patch looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> 
> Reported-by: Walt Nelson Jr <walt0924@gmail.com>
> Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/platform/efi/efi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 928bf83..e2cd38f 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -85,9 +85,10 @@ int efi_enabled(int facility)
>  }
>  EXPORT_SYMBOL(efi_enabled);
>  
> +static bool disable_runtime = false;
>  static int __init setup_noefi(char *arg)
>  {
> -	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
> +	disable_runtime = true;
>  	return 0;
>  }
>  early_param("noefi", setup_noefi);
> @@ -734,7 +735,7 @@ void __init efi_init(void)
>  	if (!efi_is_native())
>  		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
>  	else {
> -		if (efi_runtime_init())
> +		if (disable_runtime || efi_runtime_init())
>  			return;
>  		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
>  	}
> 



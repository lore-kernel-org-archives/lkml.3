Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3H3NlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:41:01 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:52781 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3H3Nk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:40:59 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 13/16] resolve warnings found on ARM compile
To: Roy Franz <roy.franz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        matt.fleming@intel.com, linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
In-Reply-To: <1376090777-20090-14-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-14-git-send-email-roy.franz@linaro.org>
Date: Fri, 30 Aug 2013 14:41:04 +0100
Message-Id: <20130830134104.81C5A3E102A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Aug 2013 16:26:14 -0700, Roy Franz <roy.franz@linaro.org> wrote:
> 2 unused labels
> 1 "value computed is not used"
> 
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>

When posting a patch to fix compile errors or warnings, it is helpful
inlude the output from the compiler with the error/warning message.

g.

> ---
>  drivers/firmware/efi/efi-stub-helper.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 4bb542f..3e82cb0 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -166,7 +166,6 @@ again:
>  		*addr = max_addr;
>  	}
>  
> -free_pool:
>  	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
>  
>  fail:
> @@ -242,7 +241,6 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>  	if (i == map_size / desc_size)
>  		status = EFI_NOT_FOUND;
>  
> -free_pool:
>  	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
>  fail:
>  	return status;
> @@ -357,7 +355,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  
>  			if (*str == '/') {
>  				*p++ = '\\';
> -				*str++;
> +				str++;
>  			} else {
>  				*p++ = *str++;
>  			}
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


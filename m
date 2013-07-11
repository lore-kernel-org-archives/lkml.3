Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3GKB47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 21:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3GKB46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:56:58 -0400
Message-ID: <51DE1111.7040809@redhat.com>
Date: Thu, 11 Jul 2013 09:57:37 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: uefi boot hang (bisected)
References: <51DD00DB.3010107@redhat.com> <51DD553B.1080701@intel.com>
In-Reply-To: <51DD553B.1080701@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 08:36 PM, Matt Fleming wrote:
> On 10/07/13 07:36, Dave Young wrote:
>> Another problem is: With this patch applied I tried noefi boot, but
>> kernel paniced, looks like efivar_init depends on efi runtime. Below
>> patches works for me about noefi boot though I'm not sure if it's a
>> right fix, please review.
> 
> It makes more sense to check in efivars.c, since none of that file can
> function without runtime serivces.
> 
> Could you try the following patch?

It works, thanks for the patch.

Tested-by: Dave Young <dyoung@redhat.com>

> 
> ---
> 
> diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> index 8bd1bb6..8a7432a 100644
> --- a/drivers/firmware/efi/efivars.c
> +++ b/drivers/firmware/efi/efivars.c
> @@ -583,6 +583,9 @@ int efivars_sysfs_init(void)
>  	struct kobject *parent_kobj = efivars_kobject();
>  	int error = 0;
>  
> +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> +		return -ENODEV;
> +
>  	/* No efivars has been registered yet */
>  	if (!parent_kobj)
>  		return 0;
> 


-- 
Thanks
Dave



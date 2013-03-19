Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989Ab3CSIsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 04:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab3CSIsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 04:48:04 -0400
Message-ID: <5148261F.3030806@redhat.com>
Date: Tue, 19 Mar 2013 16:47:27 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, kexec@lists.infradead.org,
        linux-pci@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH 10/12] acpi: Ignore acpi_rsdp kernel parameter in a secure
 boot environment
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <1363642353-30749-10-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1363642353-30749-10-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 05:32 AM, Matthew Garrett wrote:
> From: Josh Boyer <jwboyer@redhat.com>
> 
> This option allows userspace to pass the RSDP address to the kernel.  This
> could potentially be used to circumvent the secure boot trust model.
> We ignore the setting if we don't have the CAP_COMPROMISE_KERNEL capability.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  drivers/acpi/osl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 586e7e9..0ef63f1 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -245,7 +245,7 @@ early_param("acpi_rsdp", setup_acpi_rsdp);
>  acpi_physical_address __init acpi_os_get_root_pointer(void)
>  {
>  #ifdef CONFIG_KEXEC
> -	if (acpi_rsdp)
> +	if (acpi_rsdp && capable(CAP_COMPROMISE_KERNEL))
>  		return acpi_rsdp;
>  #endif
>  
> 

This does not work because capable is not usable at this early point.

Josh, could you update your fix here?

-- 
Thanks
Dave



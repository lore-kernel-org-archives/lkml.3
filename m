Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3IDAoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:44:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:34533 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934125Ab3IDAop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:44:45 -0400
Date: Wed, 4 Sep 2013 10:46:18 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 04/11] ACPI: Limit access to custom_method
In-Reply-To: <1378252218-18798-5-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041046090.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-5-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> custom_method effectively allows arbitrary access to system memory, making
> it possible for an attacker to circumvent restrictions on module loading.
> Disable it if any such restrictions have been enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Reviewed-by: James Morris <jmorris@namei.org>




> ---
>  drivers/acpi/custom_method.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index 12b62f2..50647b3 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -29,6 +29,9 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
>  	struct acpi_table_header table;
>  	acpi_status status;
>  
> +	if (secure_modules())
> +		return -EPERM;
> +
>  	if (!(*ppos)) {
>  		/* parse the table header to get the table length */
>  		if (count <= sizeof(struct acpi_table_header))
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>

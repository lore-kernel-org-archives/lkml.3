Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3H2R6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:58:47 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:47618 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3H2R6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:58:46 -0400
Date: Thu, 29 Aug 2013 13:58:43 -0400 (EDT)
From: Lenny Szubowicz <lszubowi@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
Message-ID: <359147196.9759429.1377799123451.JavaMail.root@redhat.com>
In-Reply-To: <1376928619-3775-4-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com> <1376928619-3775-4-git-send-email-matthew.garrett@nebula.com>
Subject: Re: [PATCH 04/10] ACPI: Limit access to custom_method
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: ACPI: Limit access to custom_method
Thread-Index: Mq3UuNxCEnSxIkmeuRSuAtKfjH/6XA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett@nebula.com>
> To: linux-kernel@vger.kernel.org
> Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org, "Matthew Garrett"
> <matthew.garrett@nebula.com>
> Sent: Monday, August 19, 2013 12:10:13 PM
> Subject: [PATCH 04/10] ACPI: Limit access to custom_method
> 
> custom_method effectively allows arbitrary access to system memory, making
> it possible for an attacker to circumvent restrictions on module loading.
> Disable it if any such restrictions have been enabled.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/acpi/custom_method.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
> index 12b62f2..55a013f 100644
> --- a/drivers/acpi/custom_method.c
> +++ b/drivers/acpi/custom_method.c
> @@ -7,6 +7,7 @@
>  #include <linux/kernel.h>
>  #include <linux/uaccess.h>
>  #include <linux/debugfs.h>
> +#include <linux/module.h>
>  #include <acpi/acpi_drivers.h>
>  
>  #include "internal.h"
> @@ -29,6 +30,9 @@ static ssize_t cm_write(struct file *file, const char
> __user * user_buf,
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

Nit: Don't add a second include of linux/module.h.

                      -Lenny.

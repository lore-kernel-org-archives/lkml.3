Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab3CZNVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:21:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43041 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848Ab3CZNVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:21:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: acpi: Used resource_size function
Date: Tue, 26 Mar 2013 14:28:45 +0100
Message-ID: <1984421.YzSJxzshgC@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363078382-30229-1-git-send-email-gheorghiuandru@gmail.com>
References: <1363078382-30229-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 12, 2013 10:53:02 AM Alexandru Gheorghiu wrote:
> Used resource_size function instead of explicit computation.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>

Applied to linux-pm.git/linux-next.

Thanks,
Rafael


> ---
>  drivers/acpi/osl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 586e7e9..4d31748 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1555,7 +1555,7 @@ int acpi_check_resource_conflict(const struct resource *res)
>  	else
>  		space_id = ACPI_ADR_SPACE_SYSTEM_MEMORY;
>  
> -	length = res->end - res->start + 1;
> +	length = resource_size(res);
>  	if (acpi_enforce_resources != ENFORCE_RESOURCES_NO)
>  		warn = 1;
>  	clash = acpi_check_address_range(space_id, res->start, length, warn);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

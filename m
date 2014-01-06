Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaAFLf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:35:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64956 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754177AbaAFLfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:35:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, toshi.kani@hp.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: Check if @id is NULL in acpi_table_parse()
Date: Mon, 06 Jan 2014 12:49:11 +0100
Message-ID: <1613518.D6bOWsShm6@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388997834-28028-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1388997834-28028-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 04:43:54 PM Tang Chen wrote:
> strncmp() does not check if the params are NULL. In acpi_table_parse(),
> if @id is NULL, the kernel will panic.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Queued up for 3.14 (but please use the e-mail address from MAINTAINERS next
time).  Thanks!

> ---
>  drivers/acpi/tables.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index d67a1fe..5a5263b 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -293,7 +293,7 @@ int __init acpi_table_parse(char *id, acpi_tbl_table_handler handler)
>  	if (acpi_disabled)
>  		return -ENODEV;
>  
> -	if (!handler)
> +	if (!id || !handler)
>  		return -EINVAL;
>  
>  	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

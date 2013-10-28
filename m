Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3J1Ktm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:49:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63072 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755350Ab3J1Ktk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:49:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: RUC_SoftSec <rucsoftsec@gmail.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] acpi: check return value of acpi_os_map_memory
Date: Mon, 28 Oct 2013 12:01:46 +0100
Message-ID: <3198340.cKCt9ZmSgp@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1382940259-15183-1-git-send-email-rucsoftsec@gmail.com>
References: <1382940259-15183-1-git-send-email-rucsoftsec@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 28, 2013 02:04:19 PM RUC_SoftSec wrote:
> Function acpi_os_map_memory() may return a NULL pointer, it should be validated non-NULL before used.
> This bug is found by a static tool developed by RUC_SoftSec, supported by China.X.Orion.
> 
> Signed-off-by: RUC_SoftSec <rucsoftsec@gmail.com>
> ---
>  drivers/acpi/osl.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e5f416c..bf8f93f 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -717,6 +717,8 @@ acpi_os_physical_table_override(struct acpi_table_header *existing_table,
>  
>  		table = acpi_os_map_memory(acpi_tables_addr + table_offset,
>  					   ACPI_HEADER_SIZE);
> +		if (table == NULL)

"if (!table)" perhaps?

> +			return AE_OK;

And why is it a good idea to return success then?

>  
>  		if (table_offset + table->length > all_tables_size) {
>  			acpi_os_unmap_memory(table, ACPI_HEADER_SIZE);
> 

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

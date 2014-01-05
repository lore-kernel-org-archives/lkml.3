Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaAEXQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:16:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51143 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751782AbaAEXQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:16:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 01/11] drivers: acpi: Mark the function acpi_table_checksum() as static in osl.c
Date: Mon, 06 Jan 2014 00:30:20 +0100
Message-ID: <6441094.4QZhMcC2S0@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 17, 2013 02:43:05 PM Rashika Kheria wrote:
> Marks the function acpi_table_checksum() as static in osl.c
> because it is not used outside this file.
> 
> This eliminates the following warning in osl.c:
> drivers/acpi/osl.c:547:11: warning: no previous prototype for
> ‘acpi_table_checksum’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

I've queued up patches [1-4/11] and [7-10/11] for 3.14.

I've skipped patches [5-6/11], because the general rule for ACPICA material is
that it should go through ACPICA upstream, so please submit those patches to
Bob/Lv.

I'll send a reply to patch [11/11] in a while.

Thanks!

> ---
>  drivers/acpi/osl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 54a20ff..1f4c104 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -544,7 +544,7 @@ static u64 acpi_tables_addr;
>  static int all_tables_size;
>  
>  /* Copied from acpica/tbutils.c:acpi_tb_checksum() */
> -u8 __init acpi_table_checksum(u8 *buffer, u32 length)
> +static u8 __init acpi_table_checksum(u8 *buffer, u32 length)
>  {
>  	u8 sum = 0;
>  	u8 *end = buffer + length;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

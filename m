Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3AKVzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:55:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38189 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674Ab3AKVzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:55:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: SRAT: report non-volatile memory in debug
Date: Fri, 11 Jan 2013 23:00:56 +0100
Message-ID: <3150570.0Bmftke3IF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357769168.1800.3.camel@buesod1.americas.hpqcorp.net>
References: <1357769168.1800.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 09, 2013 02:06:08 PM Davidlohr Bueso wrote:
> Just as with the other memory affinity flags, report
> non-volatile memory with ACPI debug.

Applied to the linux-next branch of the linux-pm.git tree as v3.9 material.

Thanks,
Rafael


> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  drivers/acpi/numa.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
> index cb31298..2935d3a 100644
> --- a/drivers/acpi/numa.c
> +++ b/drivers/acpi/numa.c
> @@ -116,14 +116,16 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
>  			struct acpi_srat_mem_affinity *p =
>  			    (struct acpi_srat_mem_affinity *)header;
>  			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s\n",
> +					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s%s\n",
>  					  (unsigned long)p->base_address,
>  					  (unsigned long)p->length,
>  					  p->proximity_domain,
>  					  (p->flags & ACPI_SRAT_MEM_ENABLED)?
>  					  "enabled" : "disabled",
>  					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
> -					  " hot-pluggable" : ""));
> +					  " hot-pluggable" : "",
> +					  (p->flags & ACPI_SRAT_MEM_NON_VOLATILE)?
> +					  " non-volatile" : ""));
>  		}
>  #endif				/* ACPI_DEBUG_OUTPUT */
>  		break;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

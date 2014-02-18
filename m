Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaBROGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:06:20 -0500
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:50402 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755565AbaBROGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:06:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:421:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3872:4321:4605:5007:7652:7974:10004:10400:10848:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cakes21_365832af6b552
X-Filterd-Recvd-Size: 2023
Message-ID: <1392732373.22752.22.camel@joe-AO722>
Subject: Re: [PATCH v4 5/5] ACPI: Replace printk with pr_* in tables.c
From: Joe Perches <joe@perches.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Date: Tue, 18 Feb 2014 06:06:13 -0800
In-Reply-To: <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org>
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org>
	 <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 21:55 +0800, Hanjun Guo wrote:
> This patch just do some clean up to replace printk with pr_*,
> no functional change.

trivial note:

> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
[]
> @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>  		{
>  			struct acpi_madt_local_apic *p =
>  			    (struct acpi_madt_local_apic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
> +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>  			       p->processor_id, p->id,
>  			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");

It'd be nice to realign the additional lines to the open
parenthesis, here and everywhere else in this patch

			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
				p->processor_id, p->id,
				(p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");



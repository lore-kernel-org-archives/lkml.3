Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaBSQcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:32:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34232 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbaBSQcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:32:11 -0500
Message-ID: <5304DCA2.5080906@arm.com>
Date: Wed, 19 Feb 2014 16:32:34 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep.Holla@arm.com, Lan Tianyu <tianyu.lan@intel.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linaro-acpi] [PATCH v4 5/5] ACPI: Replace printk with pr_* in
 tables.c
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org> <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org>
X-OriginalArrivalTime: 19 Feb 2014 16:32:09.0983 (UTC) FILETIME=[22D308F0:01CF2D90]
X-MC-Unique: 114021916320905901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/14 13:55, Hanjun Guo wrote:
> This patch just do some clean up to replace printk with pr_*,
> no functional change.
> 
Any particular reason for choosing just this file in this series ?
It seems but off-topic in this series. The printk format is same in almost all
other acpi files and it's better to change all or none for consistency.

> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/tables.c |   51 +++++++++++++++++++------------------------------
>  1 file changed, 20 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> index 5837f85..97bc6df 100644
> --- a/drivers/acpi/tables.c
> +++ b/drivers/acpi/tables.c
> @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>  		{
>  			struct acpi_madt_local_apic *p =
>  			    (struct acpi_madt_local_apic *)header;
> -			printk(KERN_INFO PREFIX
> -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
> +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",

You can even get rid of PREFIX by defining pr_fmt instead.

If the intention is to move to pr_* format it's better to have this as separate
patch and convert all of them. Based on the grep patterns, regex should to
helpful to find and replace them all :)

Regards,
Sudeep


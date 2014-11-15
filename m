Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaKONCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 08:02:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:4912 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbaKONCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 08:02:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,391,1413270000"; 
   d="scan'208";a="637448685"
Message-ID: <54674EC5.1050506@linux.intel.com>
Date: Sat, 15 Nov 2014 21:01:57 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Add IRQ 0 to domain debug file
References: <1416050840-24721-1-git-send-email-dbaryshkov@gmail.com>
In-Reply-To: <1416050840-24721-1-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/15 19:27, Dmitry Eremin-Solenikov wrote:
> Currently irq_domain_mapping debugfs file dumps IRQ information starting
> from IRQ 1. IRQ 0 is missing from that file. Add it to have the complete
> picture of IRQ/domains mappings.
Hi Dmitry,
	For most irqdomain interfaces, they treat irq0 as invalid
interrupt. But on x86, it's possible to use irq0 for timer. It causes
may confusion when enabling irqdomain for x86.
Regards!
Gerry

> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  kernel/irq/irqdomain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 6534ff6..0e0c7a8 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -585,7 +585,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
>  		      "chip name", (int)(2 * sizeof(void *) + 2), "chip data",
>  		      "active", "type", "domain");
>  
> -	for (i = 1; i < nr_irqs; i++) {
> +	for (i = 0; i < nr_irqs; i++) {
>  		desc = irq_to_desc(i);
>  		if (!desc)
>  			continue;
> 

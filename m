Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaIPRqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:46:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:43466 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaIPRqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:46:07 -0400
Date: Tue, 16 Sep 2014 10:45:26 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC Part2 v1 02/21] genirq: Introduce helper functions to
 support stacked irq_chip
In-Reply-To: <1410444228-3134-3-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409161044330.4247@nanos>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com> <1410444228-3134-3-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2014, Jiang Liu wrote:
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +void irq_chip_ack_parent(struct irq_data *data)
> +{
> +	data = data->parent_data;
> +	if (data && data->chip && data->chip->irq_ack)
> +		data->chip->irq_ack(data);

Why is this restricted to a single parent level and does not go down
the whole stack?

Thanks,

	tglx

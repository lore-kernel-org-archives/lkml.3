Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3AKAG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:06:56 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57399 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3AKAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:06:53 -0500
Message-ID: <50EF5798.6040405@wwwdotorg.org>
Date: Thu, 10 Jan 2013 17:06:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/14] of/pci: Provide support for parsing PCI DT ranges
 property
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-2-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 01:43 PM, Thierry Reding wrote:
> From: Andrew Murray <andrew.murray@arm.com>
> 
> DT bindings for PCI host bridges often use the ranges property to describe
> memory and IO ranges - this binding tends to be the same across architectures
> yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
> arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
> arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
> functionality provided by drivers/of/address.c.
> 
> This patch provides a common iterator-based parser for the ranges property, it
> is hoped this will reduce DT representation differences between architectures
> and that architectures will migrate in part to this new parser.
...

> diff --git a/drivers/of/address.c b/drivers/of/address.c

> +const __be32 *of_pci_process_ranges(struct device_node *node,

> +	while (from + np <= end) {
> +		u64 cpu_addr, size;
> +
> +		cpu_addr = of_translate_address(node, from + na);
> +		size = of_read_number(from + na + pna, ns);
> +		res->flags = bus->get_flags(from);
> +		from += np;
> +
> +		if (cpu_addr == OF_BAD_ADDR || size == 0)
> +			continue;

Hmmm. That seems to just ignore bad entries in the ranges property. Is
that really the right thing to do? At least printing a diagnostic might
be a good idea, even if the code does just soldier on in the hope
everything still works.

> +		res->name = node->full_name;
> +		res->start = cpu_addr;
> +		res->end = res->start + size - 1;
> +		res->parent = res->child = res->sibling = NULL;
> +		return from;
> +	}
> +
> +	return NULL;
> +}


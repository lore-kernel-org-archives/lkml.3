Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaB0ST7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:19:59 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:35072 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbaB0ST4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:19:56 -0500
Date: Thu, 27 Feb 2014 11:19:51 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140227181951.GC24656@obsidianresearch.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 01:06:39PM +0000, Liviu Dudau wrote:
> +	if (res->flags & IORESOURCE_IO) {
> +		unsigned long port;
> +		port = pci_address_to_pio(range->pci_addr);

This looks very suspicious, pci_addr is not unique across all domains,
so there is no way to convert from a pci_addr to the virtual IO
address without knowing the domain number as well.

I would like to see it be:
  port = pci_address_to_pio(range->cpu_addr);

cpu_addr is unique across all domains.

Looking at the microblaze and PPC versions I think the above version
is actually correct (assuming io_base_phys is the CPU address of the
IO window)

Jason

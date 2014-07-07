Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaGGX1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:27:55 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:64552 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGGX1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:27:53 -0400
Date: Mon, 7 Jul 2014 17:27:49 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/9] pci: Export find_pci_host_bridge() function.
Message-ID: <20140707232749.GA22939@google.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 07:43:27PM +0100, Liviu Dudau wrote:
> This is a useful function and we should make it visible outside the
> generic PCI code. Export it as a GPL symbol.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  drivers/pci/host-bridge.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> index 0e5f3c9..36c669e 100644
> --- a/drivers/pci/host-bridge.c
> +++ b/drivers/pci/host-bridge.c
> @@ -16,12 +16,13 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
>  	return bus;
>  }
>  
> -static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> +struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
>  {
>  	struct pci_bus *root_bus = find_pci_root_bus(bus);
>  
>  	return to_pci_host_bridge(root_bus->bridge);
>  }
> +EXPORT_SYMBOL_GPL(find_pci_host_bridge);

There's nothing in this series that uses find_pci_host_bridge(), so 
how about we just wait until we have something that needs it?

Also, if/when we export this, I'd prefer a name that starts with "pci_"
as most of the other interfaces do.

>  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>  				 void (*release_fn)(struct pci_host_bridge *),
> -- 
> 2.0.0
> 

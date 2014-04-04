Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaDDXj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:39:56 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53058 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaDDXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:39:52 -0400
Date: Fri, 4 Apr 2014 17:39:48 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 5/6] pci: Export find_pci_host_bridge() function.
Message-ID: <20140404233948.GC15806@google.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-6-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394811272-1547-6-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:34:31PM +0000, Liviu Dudau wrote:
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
> index 06ace62..8708b652 100644
> --- a/drivers/pci/host-bridge.c
> +++ b/drivers/pci/host-bridge.c
> @@ -17,12 +17,13 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
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

Do you have a place where you actually need to use find_pci_host_bridge()?
I'd rather not export it, even as _GPL, unless we have a user.

If we *do* export it, I'd like it to have a more conventional name, e.g.,
something starting with "pci_".

>  
>  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>  				 void (*release_fn)(struct pci_host_bridge *),
> -- 
> 1.9.0
> 

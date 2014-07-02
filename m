Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbaGBSGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:06:41 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:60480 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756237AbaGBSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:06:39 -0400
X-Greylist: delayed 732 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 14:06:39 EDT
MIME-Version: 1.0
In-Reply-To: <1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
	<1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com>
Date: Wed, 2 Jul 2014 11:06:38 -0700
Message-ID: <CACoXjck+aU33=kSy=KCGABNXNR7tj2KndAiBqEDK7wQ_Qei80Q@mail.gmail.com>
Subject: Re: [PATCH v8 2/9] pci: Export find_pci_host_bridge() function.
From: Tanmay Inamdar <tinamdar@apm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 1, 2014 at 11:43 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
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
>         return bus;
>  }
>
> -static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> +struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
>  {
>         struct pci_bus *root_bus = find_pci_root_bus(bus);
>
>         return to_pci_host_bridge(root_bus->bridge);
>  }
> +EXPORT_SYMBOL_GPL(find_pci_host_bridge);

Is there any specific reason behind making this symbol GPL? I think
the other functions in this file are just EXPORT_SYMBOL. Ultimately
companies which have non gpl Linux modules (nvidia) will face issue
using this API.

The same applies to 'of_create_pci_host_bridge'.
>
>  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>                                  void (*release_fn)(struct pci_host_bridge *),
> --
> 2.0.0
>

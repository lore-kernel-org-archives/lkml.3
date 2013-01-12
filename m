Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3ALVcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 16:32:48 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39075 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab3ALVcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 16:32:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 03/22] PCI: Set dev_node early for pci_dev
Date: Sat, 12 Jan 2013 22:38:35 +0100
Message-ID: <1734275.u3W5EUlAAy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-4-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:30 PM Yinghai Lu wrote:
> Otherwise irq_desc for pci bridge with hot-added ioapic can not be on
> local node.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/probe.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 2dcd22d..b97dea5 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1300,6 +1300,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  	dev->dev.release = pci_release_dev;
>  	pci_dev_get(dev);
>  
> +	set_dev_node(&dev->dev, pcibus_to_node(bus));
>  	dev->dev.dma_mask = &dev->dma_mask;
>  	dev->dev.dma_parms = &dev->dma_parms;
>  	dev->dev.coherent_dma_mask = 0xffffffffull;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

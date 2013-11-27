Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab3K0CF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:05:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56466 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756727Ab3K0A4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/10] PCI: Use device_release_driver in pci_stop_root_bus
Date: Wed, 27 Nov 2013 02:09:35 +0100
Message-ID: <1669330.9A2ve7gAuo@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1385429290-25397-2-git-send-email-yinghai@kernel.org>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <1385429290-25397-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 05:28:01 PM Yinghai Lu wrote:
> To be consistent with change in
> | PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
> 
> Use device_release_driver for root bus/hostbridge.
> 
> Also use device_unregister() in pci_remove_root_bus() instead of
> device_del/put_device, that will be corresponding device_register()
> for pci_create_root_bus for hostbridge.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/pci/remove.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index cc9337a..692f4c3 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -128,7 +128,7 @@ void pci_stop_root_bus(struct pci_bus *bus)
>  		pci_stop_bus_device(child);
>  
>  	/* stop the host bridge */
> -	device_del(&host_bridge->dev);
> +	device_release_driver(&host_bridge->dev);
>  }
>  
>  void pci_remove_root_bus(struct pci_bus *bus)
> @@ -147,5 +147,5 @@ void pci_remove_root_bus(struct pci_bus *bus)
>  	host_bridge->bus = NULL;
>  
>  	/* remove the host bridge */
> -	put_device(&host_bridge->dev);
> +	device_unregister(&host_bridge->dev);
>  }
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

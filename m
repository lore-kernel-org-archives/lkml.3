Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3LNUrm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:47:42 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46022 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab3LNUrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:47:39 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:47:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: ata: Mark the function as static in
 libahci.c
Message-ID: <20131214204732.GN17601@leaf>
References: <81391ee13d565f1db31247dfda803cd7123bb8a9.1387029964.git.rashika.kheria@gmail.com>
 <a4302d91071258c77de3e4086845adf630a3f8d6.1387029964.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a4302d91071258c77de3e4086845adf630a3f8d6.1387029964.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:40:21PM +0530, Rashika Kheria wrote:
> This patch marks the function ahci_port_intr() and
> ahci_hw_port_interrupt() as static in libahci.c because they are not
> used outside this file.
> 
> Thus, it also eliminates the following warnings in libahci.c:
> drivers/ata/libahci.c:1767:6: warning: no previous prototype for ‘ahci_port_intr’ [-Wmissing-prototypes]
> drivers/ata/libahci.c:1800:6: warning: no previous prototype for ‘ahci_hw_port_interrupt’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/ata/libahci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index c482f8c..36605ab 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1764,7 +1764,7 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
>  	}
>  }
>  
> -void ahci_port_intr(struct ata_port *ap)
> +static void ahci_port_intr(struct ata_port *ap)
>  {
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  	u32 status;
> @@ -1797,7 +1797,7 @@ irqreturn_t ahci_thread_fn(int irq, void *dev_instance)
>  }
>  EXPORT_SYMBOL_GPL(ahci_thread_fn);
>  
> -void ahci_hw_port_interrupt(struct ata_port *ap)
> +static void ahci_hw_port_interrupt(struct ata_port *ap)
>  {
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  	struct ahci_port_priv *pp = ap->private_data;
> -- 
> 1.7.9.5
> 

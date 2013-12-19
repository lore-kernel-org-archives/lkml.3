Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3LSO26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:28:58 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60774 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LSO24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:28:56 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 19 Dec 2013 06:28:47 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] drivers: pci: Add prototype declarations of function in
 appropriate header
Message-ID: <20131219142846.GA20678@leaf>
References: <20131219105312.GA23614@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131219105312.GA23614@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:23:12PM +0530, Rashika Kheria wrote:
> Add prototype declarations of functions arch_msi_mask_irq() and
> arch_msix_mask_irq() to header file include/linux/msi.h.
> 
> This eliminates the following warning in msi.c:
> drivers/pci/msi.c:202:12: warning: no previous prototype for ‘arch_msi_mask_irq’ [-Wmissing-prototypes]
> drivers/pci/msi.c:232:12: warning: no previous prototype for ‘arch_msix_mask_irq’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/msi.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 009b024..63b7d14 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -66,6 +66,8 @@ void default_teardown_msi_irqs(struct pci_dev *dev);
>  void default_restore_msi_irqs(struct pci_dev *dev, int irq);
>  u32 default_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
>  u32 default_msix_mask_irq(struct msi_desc *desc, u32 flag);
> +u32 arch_msi_mask_irq(struct msi_desc *desc, u32 mask, u32 flag);
> +u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag);
>  
>  struct msi_chip {
>  	struct module *owner;
> -- 
> 1.7.9.5
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBJHft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:35:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977AbaBJHfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:35:45 -0500
Message-ID: <1392015399.21271.9.camel@linux-fkkt.site>
Subject: Re: [PATCH part1 v5 5/7] PCI: Add pci_dummy_ops to isolate pci
 device temporarily
From: Oliver Neukum <oneukum@suse.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
In-Reply-To: <1392005051-54508-6-git-send-email-wangyijing@huawei.com>
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
	 <1392005051-54508-6-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Feb 2014 07:56:39 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 12:04 +0800, Yijing Wang wrote:

> +static DEFINE_SPINLOCK(pci_freeze_lock);

The lock is used only here.

> +/**
> + * pci_bus_freeze_device - freeze pci bus to access pci device
> + * @bus: the pci bus to freeze
> + *
> + * Replace pci bus ops by pci_dummy_ops, protect system from
> + * accessing pci devices.
> + */
> +void pci_bus_freeze_device(struct pci_bus *bus)
> +{
> +	struct pci_ops *ops;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pci_freeze_lock, flags);
> +	ops = pci_bus_set_ops(bus, &pci_dummy_ops);
> +	bus->save_ops = ops;
> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);

Against what exactly are you locking here?

	Regards
		Oliver



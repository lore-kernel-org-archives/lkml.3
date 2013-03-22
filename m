Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3CVJh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 05:37:58 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50008 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754536Ab3CVJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 05:37:56 -0400
Date: Fri, 22 Mar 2013 09:37:50 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/2] PCI: Introduce new MSI chip infrastructure
Message-ID: <20130322093750.GA679@arm.com>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
 <1363942307-9327-2-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1363942307-9327-2-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 08:51:46AM +0000, Thierry Reding wrote:
> index ce93a34..ea4a5be 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -58,5 +58,15 @@ extern int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>  extern void arch_teardown_msi_irqs(struct pci_dev *dev);
>  extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
>  
> +struct msi_chip {
> +	struct module *owner;
> +	struct device *dev;
> +
> +	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
> +			 struct msi_desc *desc);
> +	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
> +	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
> +			    int nvec, int type);
> +};

Is there a need to add setup_irqs and teardown_irqs functions here? This will
allow your MSI chips to support multiple MSIs per requesting device.

What about restore_msi_irqs? Does this fit in here too?

Andrew Murray

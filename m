Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137Ab3EBRU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:20:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42699 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760994Ab3EBRUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:08 -0400
Date: Thu, 2 May 2013 18:19:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        vt8500-wm8505-linux-kernel@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davem@davemloft.net
Subject: Re: [PATCHv3 3/3] net: velocity: Add platform device support to
	VIA velocity driver
Message-ID: <20130502171951.GV14496@n2100.arm.linux.org.uk>
References: <1367264772-4557-1-git-send-email-linux@prisktech.co.nz> <1367264772-4557-4-git-send-email-linux@prisktech.co.nz> <20130429230450.GA2620@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130429230450.GA2620@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 01:04:50AM +0200, Francois Romieu wrote:
> Tony Prisk <linux@prisktech.co.nz> :
> [...]
> > +static int velocity_remove(void *pdev, enum velocity_bus_type bustype)
> > +{
> > +	struct net_device *netdev;
> > +	struct velocity_info *vptr;
> > +	int pci = (bustype == BUS_PCI) ? 1 : 0;
> > +
> > +	if (pci)
> > +		netdev = pci_get_drvdata(pdev);
> > +	else
> > +		netdev = platform_get_drvdata(pdev);
> 
> The caller knows how to retrieve the net_device pointer, whence
> the struct velocity_info pointer, whence any bustype dependent
> function pointer to alleviate the "if (pci)" and CONFIG stuff.
> 
> If you are not convinced, please consider turning the void *
> into an union *.

The other thing here is that you can just pass a struct device into
these and retrieve the same driver data via:

	netdev = dev_get_drvdata(dev);

as:

static inline void *platform_get_drvdata(const struct platform_device *pdev)
{
        return dev_get_drvdata(&pdev->dev);
}

static inline void *pci_get_drvdata(struct pci_dev *pdev)
{
        return dev_get_drvdata(&pdev->dev);
}

So there's no need for void * or union nonsense.

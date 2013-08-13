Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3HMOBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:01:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33857 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3HMOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:01:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19yT/YbToJXaJp6Z3sEIgYZ9/hPY7W0FrE=
Date: Tue, 13 Aug 2013 10:01:30 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] ARM: dove: DT PCIe support
Message-ID: <20130813140130.GA25111@titan.lakedaemon.net>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

On Tue, Aug 13, 2013 at 02:25:19PM +0200, Sebastian Hesselbarth wrote:
> This patch set adds support for the PCIe controllers found on Marvell
> Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.

Well, when it rains, it pours.  If this series looks good to you, I'll
go ahead and add it on top of Thomas' patches.

> The ARM Dove related patches have already been taken by Jason Cooper
> and have been removed from v2 of this patch set. Changelog is added
> to the individual patch emails.
> 
> Patches 1 and 2 fix some minor issues with pci-mvebu by moving
> clk_prepare_enable before accessing any controller registers and
> counting sucessfully registered ports only.
> 
> Patch 3 converts pci-mvebu from subsys_initcall registration to
> normal platform driver registration to allow it to fail with
> EPROBE_DEFER later.
> 
> Patch 4 adds DT parsing for reset (PERST#) GPIO pins and delay to
> wait for PCIe devices after reset de-assertion.
> 
> Patch 5 finally adds a compatible to pci-mvebu for Dove SoCs.
> 
> [Patch 6-9 have already been taken by Jason Cooper]

These were the dts files.

> Sebastian Hesselbarth (5):
>   PCI: mvebu: move clock enable before register access
>   PCI: mvebu: increment nports only for registered ports
>   PCI: mvebu: remove subsys_initcall
>   PCI: mvebu: add support for reset on GPIO
>   PCI: mvebu: add support for Marvell Dove SoCs
> 
>  .../devicetree/bindings/pci/mvebu-pci.txt          |    7 ++
>  drivers/pci/host/Kconfig                           |    2 +-
>  drivers/pci/host/pci-mvebu.c                       |   99 +++++++++++++-------
>  3 files changed, 71 insertions(+), 37 deletions(-)

Should be pretty isolated.

thx,

Jason.

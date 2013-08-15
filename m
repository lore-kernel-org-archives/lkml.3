Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab3HOQRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:17:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756721Ab3HOQRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:17:10 -0400
Date: Thu, 15 Aug 2013 18:16:51 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Thierry Reding <thierry.reding@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/5] ARM: dove: DT PCIe support
Message-ID: <20130815181651.2f336cff@skate>
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On Tue, 13 Aug 2013 14:25:19 +0200, Sebastian Hesselbarth wrote:
> This patch set adds support for the PCIe controllers found on Marvell
> Dove SoCs. It depends on mvebu-pci patches sent by Thomas Petazzoni.
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
> 
> Sebastian Hesselbarth (5):
>   PCI: mvebu: move clock enable before register access
>   PCI: mvebu: increment nports only for registered ports
>   PCI: mvebu: remove subsys_initcall
>   PCI: mvebu: add support for reset on GPIO
>   PCI: mvebu: add support for Marvell Dove SoCs

I've just seen that Jason Cooper has already sent the PR for this code,
but anyway, I just tested mvebu/for-next on my Armada XP GP board, and
the PCIe + MSI continues to work nicely, even with your code
integrated. So:

Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

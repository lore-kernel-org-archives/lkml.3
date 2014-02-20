Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaBTAun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:50:43 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53777 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbaBTAuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:50:40 -0500
Date: Wed, 19 Feb 2014 21:50:28 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>
Subject: Re: [PATCH 0/2] Translate of PCI address without PCI enabled
Message-ID: <20140220005027.GA5721@localhost>
References: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:14:54PM +0100, Gregory CLEMENT wrote:
> Hello,
> 
> This patch set makes the use of the of PCI address translator less
> restrictive. At the end it will allow to use the mvebu_get_soc_id
> unconditionally.
> 
> The mvebu SoC (such as Kirkwood, Dove or Armada XP for instance) come
> with an IP of a PCI controller. The ID and the revision of a SoC are
> stored in the registers of this controller. Being able to get this
> information allows to deals with errata more dynamically.
> 
> To manage to read this information, we need to map the registers, and
> for this we need to use the of PCI translator which depend of the PCI
> support.
> 
> However there are mvebu board without any PCI devices, and where
> selecting the PCI support would be useless.
> 
> Moreover translating an address from a PCI node of the device-tree
> into a CPU physical address doesn't require the core PCI
> support. Those translations are just related to the device tree
> itself.
> 
> The 1st patch introduces a new config symbol: OF_ADDRESS_PCI, which
> will be selected as soon as PCI will be selected, so we remains in the
> same situation the current code. It should go to the of tree.
> 
> The 2nd patch selects OF_ADDRESS_PCI as soon as ARCH_MVEBU will be
> selected. This will make mvebu_get_soc_id available even without the
> PCI support. It should go to the mvebu tree.
> 
> Thanks,
> 
> Gregory CLEMENT (2):
>   of: Allows to use the PCI translator without the PCI core
>   ARM: mvebu: Allows to get the SoC ID even without PCI enabled
> 
>  arch/arm/mach-mvebu/Kconfig | 1 +
>  drivers/of/Kconfig          | 4 ++++
>  drivers/of/address.c        | 8 +++++---
>  3 files changed, 10 insertions(+), 3 deletions(-)
> 
> -- 
> 1.8.1.2
> 

On XP GP and CONFIG_PCI=n, without the patches I get this:

  mvebu-soc-id: cannot map registers

and after applying the patches I have:

  mvebu-soc-id: MVEBU SoC ID=0x7846, Rev=0x2

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Thanks for taking care of this.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

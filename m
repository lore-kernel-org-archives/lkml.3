Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaC0MkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:40:15 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:48351 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbaC0MkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:40:11 -0400
Date: Thu, 27 Mar 2014 13:38:23 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Tejun Heo <tj@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ata: fix Marvell SATA driver dependencies
Message-ID: <20140327123823.GM25349@lunn.ch>
References: <1668037.2oe7J2B7N4@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1668037.2oe7J2B7N4@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 01:23:39PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Make sata_mv host driver depend on PCI || ARCH_DOVE || ARCH_KIRKWOOD ||
> ARCH_MV78XX0 || ARCH_MVEBU || ARCH_ORION5X config options as Marvell
> SATA support covers both Marvell PCI devices and Marvell Dove, Kirkwood,
> MV78xx0, Armada 370/XP and Orion5x SoCs (for non-PCI devices the driver
> to work requires suitable device tree node to be defined).

Good old fashioned platform driver will also work. In fact, 95% of Orion5x
and mv78xx0 devices don't have DT yet.

You might also be able to simplify it to

PCI || PLAT_ORION || COMPILE_TEST

But i suggest you build test to make sure.

    Andrew

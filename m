Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbaEFMm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:42:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51000 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756257AbaEFMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:42:51 -0400
Date: Tue, 6 May 2014 14:42:42 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-usb@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Mathias Nyman <mathias.nyman@intel.com>, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140506144242.1b098f30@skate>
In-Reply-To: <4660313.evfclGtT1x@wuerfel>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
	<61061197.hLhKsFqJLF@wuerfel>
	<20140506141023.715b932d@skate>
	<4660313.evfclGtT1x@wuerfel>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd Bergmann,

On Tue, 06 May 2014 14:21:55 +0200, Arnd Bergmann wrote:

> > That's not what we do for any of the other drivers that use the
> > MVEBU_MBUS functions.
> 
> Fair enough. I guess using ARCH_MVEBU as the dependency works as well
> because it implies MVEBU_MBUS. However, you can't use COMPILE_TEST
> then because the driver itself needs the interfaces provided by MBUS.
> 
> It could be
> 
> 	depends on ARCH_MVEBU || (MVEBU_MBUS && COMPILE_TEST)
> 
> to describe the dependency most accurately.

Right, that would work indeed, but is in fact not necessary, at least
for this driver. The only mbus function used by this driver is
mv_mbus_dram_info(), and <linux/mbus.h> provides an empty stub for this
function (returning NULL) when MVEBU_MBUS is disabled. So from a
compile time point of view, there is no problem with compiling the
xhci-plat driver with MVEBU_MBUS disabled, so in fact:

	depends on ARCH_MVEBU || COMPILE_TEST

will work just fine.

The only case where this doesn't work is for drivers that use the other
mbus functions to create/remove windows, because no stubs are provided
for these ones. However, as things are today, the only driver in this
situation is the pci-mvebu driver, and its dependency is:

	depends on ARCH_MVEBU || ARCH_DOVE || ARCH_KIRKWOOD

For this one, we could indeed add || (MVEBU_MBUS && COMPILE_TEST)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

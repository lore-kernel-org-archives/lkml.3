Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbbAHBDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:03:35 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:60006 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbAHBDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:03:34 -0500
Date: Wed, 7 Jan 2015 17:03:29 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Peter Pan =?utf-8?B?5r2Y5qCLIChwZXRlcnBhbmRvbmcp?= 
	<peterpandong@micron.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Qi Wang =?utf-8?B?546L6LW3IChxaXdhbmcp?= <qiwang@micron.com>,
        Frank Liu =?utf-8?B?5YiY576kIChmcmFua2xpdSk=?= 
	<frankliu@micron.com>,
        Melanie Zhang =?utf-8?B?5byg54eVIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>
Subject: Re: [PATCH 0/3] An alternative to SPI NAND
Message-ID: <20150108010257.GP9759@ld-irv-0074>
References: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87F60714EC601C4C83DFF1D2E3D390A04AB3F3@NTXXIAMBX02.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:47:24AM +0000, Peter Pan 潘栋 (peterpandong) wrote:
> Documentation/devicetree/bindings/mtd/spi-nand.txt |   22 +
> drivers/mtd/Kconfig                                |    2 +
> drivers/mtd/Makefile                               |    1 +
> drivers/mtd/spi-nand/Kconfig                       |    7 +
> drivers/mtd/spi-nand/Makefile                      |    3 +
> drivers/mtd/spi-nand/spi-nand-base.c               | 2034 ++++++++++++++++++++
> drivers/mtd/spi-nand/spi-nand-bbt.c                | 1279 ++++++++++++

I can already tell by the diffstat that I don't like this. We probably
don't need 3000 new lines of code for this, but we especially don't want
to duplicate nand_bbt.c. It won't take a lot of work to augment
nand_bbt.c to make it shareable. (I can whip that patch up if needed.)

I'll still take a look at the rest of the code eventually, but just
wanted to give my 2 cents up front.

> drivers/mtd/spi-nand/spi-nand-device.c             |  281 +++
> include/linux/mtd/spi-nand.h                       |  317 +++
> 9 files changed, 3946 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt
> create mode 100644 drivers/mtd/spi-nand/Kconfig
> create mode 100644 drivers/mtd/spi-nand/Makefile
> create mode 100644 drivers/mtd/spi-nand/spi-nand-base.c
> create mode 100644 drivers/mtd/spi-nand/spi-nand-bbt.c
> create mode 100644 drivers/mtd/spi-nand/spi-nand-device.c
> create mode 100644 include/linux/mtd/spi-nand.h

Brian

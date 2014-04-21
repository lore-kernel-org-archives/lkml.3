Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaDUV35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:29:57 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33536 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaDUV3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:29:54 -0400
X-Auth-Info: 4orBAbtNI5hwJA61HdUBhJQ/+k6wYLVxqnnl4tbppoA=
From: Marek Vasut <marex@denx.de>
To: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH 0/5] defconfigs: add MTD_SPI_NOR (dependency for M25P80)
Date: Mon, 21 Apr 2014 16:52:39 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Steven Miao <realmz6@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com> <20140417105302.GA32603@ulmo> <20140418063054.GK5512@norris-Latitude-E6410>
In-Reply-To: <20140418063054.GK5512@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404211652.39704.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 18, 2014 at 08:30:54 AM, Brian Norris wrote:
> Hi,
> 
> On Thu, Apr 17, 2014 at 12:53:03PM +0200, Thierry Reding wrote:
> > On Thu, Apr 17, 2014 at 12:21:44AM -0700, Brian Norris wrote:
> > > We are introducing a new SPI-NOR library/framework for MTD, to support
> > > various types of SPI-NOR flash controllers which require (or benefit
> > > from) intimate knowledge of the flash interface, rather than just the
> > > relatively dumb SPI interface. This library borrows much of the m25p80
> > > driver for its abstraction and moves this code into a spi-nor module.
> > 
> > If this is a common library, then the more common approach to solve this
> > would be to have each driver that uses it to select MTD_SPI_NOR rather
> > than depend on it. That way you can drop this whole series to update the
> > default configurations.
> 
> But does MTD_SPI_NOR (and drivers/mtd/spi-nor/) qualify as a "library"
> or as a "subsystem"? I thought the latter were typically expected to be
> user-selectable options, not automatically-"select"ed.

I agree the "subsystem" is user-selectable while the "library" is to be 
'select'ed .

> I would say that, except for its age, MTD_SPI_NOR is very similar in to
> MTD_NAND (driver/mtd/nand/), which I'd consider a kind of subsystem, and
> which users must select before they are asked about drivers which fall
> under its category.
> 
> Perhaps my usage of the word "library" in the description was a mistake,
> as I don't exactly consider it like a library in the sense of many other
> "select"ed libraries.

It did look like a library to me at first, but it's rather a subsystem that 
contains a small library in it. Thus, I retract my previous comment about using 
'select' and add :

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut

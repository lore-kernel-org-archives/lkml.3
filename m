Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbaD2TGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:06:10 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:47230 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaD2TGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:06:07 -0400
Date: Tue, 29 Apr 2014 12:06:03 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        linux-mtd@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency for
 M25P80)
Message-ID: <20140429190603.GB9418@norris-Latitude-E6410>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A8FC9.8040707@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Apr 25, 2014 at 10:39:37AM -0600, Stephen Warren wrote:
> On 04/17/2014 01:21 AM, Brian Norris wrote:
> > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> > relevant defconfigs.
> > 
> > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> I hadn't realized that the problem this patch solves was already present
> in the code, so this patch is simply catching up the defconfigs rather
> than part of a series which changed the code to cause the problem.

Yes, this is "catching up the defconfigs." The SPI_NOR framework is new,
and I didn't want to generate defconfig noise until a few things
stabilized (particularly, its Kconfig symbol name).

> So, this needs to be applied ASAP.
> 
> I think this should be split it up so that each defconfig can go through
> the tree that owns it to avoid conflicts. If you repost split up, I can
> apply the tegra_defconfig change to the Tegra tree.

OK, I'll try to split it up. Is ARM unique in tracking defconfigs in
separate trees? I assume MIPS, PowerPC, and Blackfin won't require the
same splitting? I'd like to avoid 31 patches when <20 could suffice.

I'll also rebase on linux-next. I think there may be a few conflicts.

Thanks,
Brian

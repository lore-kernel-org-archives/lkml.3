Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaHEDBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 23:01:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54609 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaHEDBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 23:01:43 -0400
Date: Mon, 4 Aug 2014 20:01:40 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: bpqw <bpqw@micron.com>
Cc: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "ron@debian.org" <ron@debian.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
Message-ID: <20140805030140.GJ3711@ld-irv-0074>
References: <CB9F11E856CFD04BB18EC1C68F2598931B1112@NTXXIAMBX01.xacn.micron.com>
 <20140728061006.GC3095@norris-Latitude-E6410>
 <CB9F11E856CFD04BB18EC1C68F2598931B1342@NTXXIAMBX01.xacn.micron.com>
 <20140804224757.GH3711@ld-irv-0074>
 <CB9F11E856CFD04BB18EC1C68F2598931B1724@NTXXIAMBX01.xacn.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CB9F11E856CFD04BB18EC1C68F2598931B1724@NTXXIAMBX01.xacn.micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 01:54:07AM +0000, bpqw wrote:
> From 0304e9618d8c3ef5360b611f881f1b1bed08be06 Mon Sep 17 00:00:00 2001
> From: White Ding <bpqw@micron.com>
> Date: Thu, 24 Jul 2014 00:10:45 +0800
> Subject: [PATCH 1/1] mtd:nand:fix nand_lock/unlock() function
> 
> Do nand reset before write protect check.
> 
> If we want to check the WP# low or high through STATUS READ and check bit 7,
> we must reset the device, other operation (eg.erase/program a locked block) can
> also clear the bit 7 of status register.
> 
> As we know the status register can be refreshed, if we do some operation to trigger it,
> for example if we do erase/program operation to one block that is locked, then READ STATUS,
> the bit 7 of READ STATUS will be 0 indicate the device in write protect, then if we do
> erase/program operation to another block that is unlocked, the bit 7 of READ STATUS will
> be 1 indicate the device is not write protect.
> Suppose we checked the bit 7 of READ STATUS is 0 then judge the WP# is low (write protect),
> but in this case the WP# maybe high if we do erase/program operation to a locked block, 
> so we must reset the device if we want to check the WP# low or high through STATUS READ and 
> check bit 7.
> 
> Signed-off-by: White Ding <bpqw@micron.com>

Thanks. Queued to l2-mtd.git/next.

Brian

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbaEIWYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 18:24:16 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49808 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaEIWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 18:24:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Date: Sat, 10 May 2014 00:24:02 +0200
Message-ID: <4160510.VJSlHZLhNz@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140509220915.GA391@arch.cereza>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <20140509212810.GF18257@obsidianresearch.com> <20140509220915.GA391@arch.cereza>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jtSp2IflmEyfzuqPrzLLOrnlGA+9uUH5usara6Fui/f
 ZGayQZFyTpWRAXx3A3GoxwLsE/jN3lEpEC4pFBRAx525UQ5ygV
 gijWrwbsHWs01zKyuwuc1qu5M8aGKJEq5l4Tybjv0X0JoafQ62
 dSTatFTEriMASb66G3I5K+YH6AXWPBiYyRnLdU4cYkIJ1IiHHV
 K90PH/rbkm72DUGbEaPMtH0yNJSpL8H9Bj6bx4lmwfPy9ue8JG
 edQB+VWdlR6m2XE9aql3jWkFK8+Qq+WE2+IYAsC5idntFakmho
 AeX5mhi6xHiYGuHSsrLXxujBCkquLl3JToTCDH6D7RJr+y0SeF
 TgLVZqNTrXIxFF+DbK+0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 May 2014 19:09:15 Ezequiel Garcia wrote:
> # time nanddump /dev/mtd5 -f /dev/null -q
> real    0m 5.82s
> user    0m 0.20s
> sys     0m 5.60s
> 
> Jason: Care to submit a proper patch?
> 
> On 08 May 04:56 PM, Arnd Bergmann wrote:
> > Ok, that is a noticeable difference. For scale, what is the size of that partition?
> 
> The board is Openblocks A6, running mainline.
> 
> # cat /proc/mtd 
> dev:    size   erasesize  name
> mtd0: 00090000 00004000 "uboot"
> mtd1: 00044000 00004000 "env"
> mtd2: 00024000 00004000 "test"
> mtd3: 00400000 00004000 "conf"
> mtd4: 01d20000 00004000 "linux"
> mtd5: 01dec000 00004000 "user"

Ok, so it takes 5.6 seconds in kernel mode to access 31MB, which comes down
to 5.60MB/s. That isn't very fast compared to the time the CPU should take
for those instructions, so I'm surprised it actually makes any difference
at all.

There isn't a usable slave DMA engine in Armada XP by chance?

	Arnd

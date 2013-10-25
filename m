Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3JYRcV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:32:21 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64023 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JYRcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:32:19 -0400
Date: Fri, 25 Oct 2013 10:32:15 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Huang Shijie <b32955@freescale.com>, Marek Vasut <marex@denx.de>
Subject: [GIT PULL] final MTD fixes for 3.12
Message-ID: <20131025173215.GH20061@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull a few more MTD regression fixes for 3.12?

I signed my tag this time, although you still have little reason to trust
it.

Thanks,
Brian

The following changes since commit b291a22952e74bb2fcf9c57c6d8bae52a4f197e2:

  Merge tag 'for-linus-20131008' of git://git.infradead.org/linux-mtd (2013-10-10 11:30:33 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mtd.git tags/for-linus-20131025

for you to fetch changes up to 031e2777e03401d629e62602c8ce42b017732d4d:

  mtd: gpmi: fix ECC regression (2013-10-25 10:09:43 -0700)

----------------------------------------------------------------

A few more last-minute regression fixes, prepared jointly by me and David
Woodhouse:

* Revert pxa3xx to its old name to avoid breaking existing 'mtdparts=' boot
  strings.

* Return GPMI NAND to its legacy ECC layout for backwards compatibility. We
  will revisit this in 3.13.

A note from David on the latter fix: "This leaves a harmless cosmetic warning
about an unused function. At this point in the cycle I really don't care."

----------------------------------------------------------------
David Woodhouse (1):
      mtd: gpmi: fix ECC regression

Ezequiel Garcia (1):
      mtd: nand: pxa3xx: Fix registered MTD name

 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 2 +-
 drivers/mtd/nand/pxa3xx_nand.c         | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaG3OxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:53:06 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51767 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaG3OxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:53:04 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 30 Jul 2014 08:52:43 -0600
X-Google-Sender-Auth: mWTXGwbP7dWrmWHD_KSRzzj8lVU
Message-ID: <CACxGe6vLUtEGAFs+cx4KxwXyXwrTo4Ksw36wLeBnWc8GMBxwfw@mail.gmail.com>
Subject: [GIT PULL] Last minute bug fix for Exynos platform
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This bug fix has been brewing for a while. I hate sending it to you so
late, but I only got confirmation that it solves the problem this past
weekend. The diff looks big for a bug fix, but the majority of it is
only executed in the Exynos quirk case. Unfortunately it required
splitting early_init_dt_scan() in two and adding quirk handling in the
middle of it on ARM.

If you're not happy pulling at this late stage then I'll add it to my
v3.17 merge queue and ask Greg to pull it into stable.

g.

The following changes since commit 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91:

  Linux 3.16-rc7 (2014-07-27 12:41:55 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to 5a12a597a8627b91fd9d94365853f9f69a4f399c:

  arm: Add devicetree fixup machine function (2014-07-29 21:26:49 -0600)

----------------------------------------------------------------
Device tree Exynos bug fix for v3.16-rc7

Exynos has buggy firmware that puts bad data into the memory node. Commit
1c2f87c2 (ARM: Get rid of meminfo) exposed the bug by dropping the artificial
upper bound on the number of memory banks that can be added. Exynos fails to
boot after that commit. This branch fixes it by splitting the early DT parse
function and inserting a fixup hook. Exynos uses the hook to correct the DT
before parsing memory regions.

----------------------------------------------------------------
Laura Abbott (3):
      of: Split early_init_dt_scan into two parts
      of: Add memory limiting function for flattened devicetrees
      arm: Add devicetree fixup machine function

 arch/arm/include/asm/mach/arch.h |  1 +
 arch/arm/kernel/devtree.c        |  8 ++++-
 arch/arm/mach-exynos/exynos.c    | 10 ++++++
 drivers/of/fdt.c                 | 66 +++++++++++++++++++++++++++++++++++++++-
 include/linux/of_fdt.h           |  3 ++
 5 files changed, 86 insertions(+), 2 deletions(-)

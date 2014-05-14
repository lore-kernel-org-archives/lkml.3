Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaENFTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:19:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:43790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaENFTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:19:46 -0400
Message-ID: <1400044769.17624.237.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 14 May 2014 15:19:29 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a couple of fixes for 3.15. One from Anton fixes a nasty regression
I introduced when trying to fix a loss of irq_work whose consequences is
that we can completely lose timer interrupts on a CPU... not pretty.

The other one is a change to our PCIe reset hook to use a firmware call
instead of direct config space accesses to trigger a fundamental reset
on the root port. This is necessary so that the FW gets a chance to
disable the link down error monitoring, which would otherwise trip
and cause subsequent fatal EEH error.

Cheers,
Ben.

The following changes since commit e4565362c7adc31201135c4b6d649fc1bdc3bf20:

  powerpc/4xx: Fix section mismatch in ppc4xx_pci.c (2014-04-28 16:32:53 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 8050936caf125fbe54111ba5e696b68a360556ba:

  powerpc: irq work racing with timer interrupt can result in timer interrupt hang (2014-05-12 14:29:28 +1000)

----------------------------------------------------------------
Anton Blanchard (1):
      powerpc: irq work racing with timer interrupt can result in timer interrupt hang

Gavin Shan (1):
      powerpc/powernv: Reset root port in firmware

 arch/powerpc/kernel/time.c                | 3 ---
 arch/powerpc/platforms/powernv/eeh-ioda.c | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)



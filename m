Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaE1D3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:29:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:39190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaE1D3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:29:15 -0400
Message-ID: <1401247741.8262.21.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 28 May 2014 13:29:01 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a pair of powerpc fixes for 3.15 which are also going to stable.

One's a fix for building with newer binutils (the problem currently only
affects the BookE kernels but the affected macro might come back into
use on BookS platforms at any time). Unfortunately, the binutils maintainer
did a backward incompatible change to a construct that we use so we have
to add Makefile check.

The other one is a fix for CPUs getting stuck in kexec when running single
threaded. Since we routinely use kexec on power (including in our newer
bootloaders), I deemed that important enough.

Cheers,
Ben.

The following changes since commit 8050936caf125fbe54111ba5e696b68a360556ba:

  powerpc: irq work racing with timer interrupt can result in timer interrupt hang (2014-05-12 14:29:28 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 011e4b02f1da156ac7fea28a9da878f3c23af739:

  powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode (2014-05-28 13:24:26 +1000)

----------------------------------------------------------------
Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Srivatsa S. Bhat (1):
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode

 arch/powerpc/Makefile                  | 4 +++-
 arch/powerpc/include/asm/ppc_asm.h     | 7 ++++++-
 arch/powerpc/kernel/machine_kexec_64.c | 2 +-
 kernel/kexec.c                         | 8 ++++++++
 4 files changed, 18 insertions(+), 3 deletions(-)



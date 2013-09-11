Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3IKDWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 23:22:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:44665 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3IKDWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 23:22:37 -0400
Message-ID: <1378869743.3783.8.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 11 Sep 2013 13:22:23 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful of small powerpc fixes. A couple of section mismatches
(always worth fixing), a missing export of a new symbol causing build
failures of modules, a page fault deadlock fix (interestingly that
bug has been around for a LONG time, though it seems to be more easily
triggered by KVM) and fixing pseries default idle loop in the absence of
the cpuidle drivers (such as during boot).

Cheers,
Ben.

The following changes since commit 8d7551eb1916832f2a5b27346edf24e7b2382f67:

  Merge tag 'cris-for-3.12' of git://jni.nu/cris (2013-09-10 14:55:16 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 363edbe2614aa90df706c0f19ccfa2a6c06af0be:

  powerpc: Default arch idle could cede processor on pseries (2013-09-11 11:41:54 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc: Fix possible deadlock on page fault

Guenter Roeck (1):
      powerpc: Export cpu_to_chip_id() to fix build error

Vaidyanathan Srinivasan (1):
      powerpc: Default arch idle could cede processor on pseries

Vladimir Murzin (2):
      powerpc: Fix section mismatch warning for prom_rtas_call
      fbdev/ps3fb: Fix section mismatch warning for ps3fb_probe

 arch/powerpc/kernel/prom_init.c        |  3 ++-
 arch/powerpc/kernel/smp.c              |  1 +
 arch/powerpc/mm/fault.c                | 13 ++++++++++---
 arch/powerpc/platforms/pseries/setup.c | 31 +++++++++++++++++++++----------
 drivers/video/ps3fb.c                  |  2 +-
 5 files changed, 35 insertions(+), 15 deletions(-)



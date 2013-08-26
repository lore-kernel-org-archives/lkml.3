Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3HZDAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 23:00:34 -0400
Received: from mail7.windriver.com ([128.224.252.3]:55628 "EHLO
	mail7.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3HZDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 23:00:33 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 0/8] powerpc/book3e: support kexec and kdump
Date: Mon, 26 Aug 2013 11:00:50 +0800
Message-ID: <1377486058-30379-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

I don't see any further comments, so could you merge this kindly?

This patchset is used to support kexec and kdump on book3e.

Tested on fsl-p5040 DS.

v4:

* rebase on next branch

v3:

* add one patch to rename interrupt_end_book3e with __end_interrupts
  then we can have a unique lable for book3e and book3s.
* add some comments for "book3e/kexec/kdump: enable kexec for kernel"
* clean "book3e/kexec/kdump: introduce a kexec kernel flag"

v2:
* rebase on merge branch

v1:
* improve some patch head
* rebase on next branch with patch 7

----------------------------------------------------------------
Tiejun Chen (8):
      powerpc/book3e: rename interrupt_end_book3e with __end_interrupts
      powerpc/book3e: support CONFIG_RELOCATABLE
      book3e/kexec/kdump: enable kexec for kernel
      book3e/kexec/kdump: create a 1:1 TLB mapping
      book3e/kexec/kdump: introduce a kexec kernel flag
      book3e/kexec/kdump: implement ppc64 kexec specfic
      book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
      book3e/kexec/kdump: recover "r4 = 0" to create the initial TLB

 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/exception-64e.h |   11 +++
 arch/powerpc/include/asm/page.h          |    2 +
 arch/powerpc/include/asm/smp.h           |    1 +
 arch/powerpc/kernel/exceptions-64e.S     |   26 +++++-
 arch/powerpc/kernel/head_64.S            |   48 +++++++++-
 arch/powerpc/kernel/machine_kexec_64.c   |  148 +++++++++++++++++-------------
 arch/powerpc/kernel/misc_64.S            |   67 +++++++++++++-
 arch/powerpc/platforms/85xx/smp.c        |   33 ++++++-
 9 files changed, 257 insertions(+), 81 deletions(-)

Tiejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab3FTHxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:53:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:40742 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3FTHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:53:11 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [v2][PATCH 0/7] powerpc/book3e: support kexec and kdump
Date: Thu, 20 Jun 2013 15:53:10 +0800
Message-ID: <1371714797-7898-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is used to support kexec and kdump on book3e.

Tested on fsl-p5040 DS.

v2:
* rebase on merge branch as Ben mention now.

v1:
* improve some patch head
* rebase on next branch with patch 7

--------------------------------------------------------------------------------
Tiejun Chen (7):
      powerpc/book3e: support CONFIG_RELOCATABLE
      book3e/kexec/kdump: enable kexec for kernel
      book3e/kexec/kdump: create a 1:1 TLB mapping
      book3e/kexec/kdump: introduce a kexec kernel flag
      book3e/kexec/kdump: implement ppc64 kexec specfic
      book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET
      book3e/kexec/kdump: recover "r4 = 0" to create the initial TLB

 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/exception-64e.h |    8 ++++
 arch/powerpc/include/asm/page.h          |    2 +
 arch/powerpc/include/asm/smp.h           |    3 ++
 arch/powerpc/kernel/exceptions-64e.S     |   15 ++++++-
 arch/powerpc/kernel/head_64.S            |   47 +++++++++++++++++++--
 arch/powerpc/kernel/machine_kexec_64.c   |    6 +++
 arch/powerpc/kernel/misc_64.S            |   67 +++++++++++++++++++++++++++++-
 arch/powerpc/lib/feature-fixups.c        |    7 ++++
 arch/powerpc/platforms/85xx/smp.c        |   27 ++++++++++++
 10 files changed, 178 insertions(+), 6 deletions(-)

Tiejun

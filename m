Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319Ab3DDMwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:52:08 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6456 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759905Ab3DDMwF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:52:05 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>, <masami.hiramatsu.pt@hitachi.com>,
        <davem@davemloft.net>, <anil.s.keshavamurthy@intel.com>,
        <ananth@in.ibm.com>, <radovan.lekanovic@sonymobile.com>,
        <bjorn.davidsson@sonymobile.com>, <oskar.andero@sonymobile.com>
Subject: [PATCH v2 0/4] kprobes: split blacklist into common and arch
Date: Thu, 4 Apr 2013 14:51:25 +0200
Message-ID: <1365079889-21525-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 2 of the patch-set for splitting arch and common kprobe
blackpoints.

Changes since last version are:
- Don't use double pointer for blacklist.
- Add mutex around blacklist initialization code.
- Use unlikely in if-statement around init_kprobe_blacklist() calls.

I have also included linux-arch in Cc for this post.

-Oskar

Björn Davidsson (1):
  kprobes: move x86-specific blacklist symbols to arch directory

Oskar Andero (2):
  kprobes: split blacklist into common and arch
  kprobes: replace printk with pr_-functions

Toby Collett (1):
  kprobes: delay blacklist symbol lookup until we actually need it

 arch/arc/kernel/kprobes.c      |   3 +
 arch/arm/kernel/kprobes.c      |   2 +
 arch/avr32/kernel/kprobes.c    |   3 +
 arch/ia64/kernel/kprobes.c     |   3 +
 arch/mips/kernel/kprobes.c     |   3 +
 arch/mn10300/kernel/kprobes.c  |   2 +
 arch/powerpc/kernel/kprobes.c  |   3 +
 arch/s390/kernel/kprobes.c     |   3 +
 arch/sh/kernel/kprobes.c       |   3 +
 arch/sparc/kernel/kprobes.c    |   3 +
 arch/x86/kernel/kprobes/core.c |   7 ++
 kernel/kprobes.c               | 152 ++++++++++++++++++++++++++---------------
 12 files changed, 133 insertions(+), 54 deletions(-)

-- 
1.8.1.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572Ab3DCI3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:29:16 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8686 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761522Ab3DCI3O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:29:14 -0400
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>
Subject: [PATCH 0/4] kprobes: split blacklist into common and arch
Date: Wed, 3 Apr 2013 10:28:50 +0200
Message-ID: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a slight rework of the following patches which I posted earlier:
[PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
[PATCH] delay blacklist symbol lookup until we actually need it

This serie includes a patch that moves the architecture dependent black points
to the arch/ directory and the x86 patch was modified to follow that patch.

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
 kernel/kprobes.c               | 149 ++++++++++++++++++++++++++---------------
 12 files changed, 130 insertions(+), 54 deletions(-)

-- 
1.8.1.5


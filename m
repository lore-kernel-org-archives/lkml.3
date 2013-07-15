Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3GOVvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:51:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33798 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757274Ab3GOVvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:51:41 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [v3.11-rc1 PATCH 0/5] printk: Initial restructuring
Date: Mon, 15 Jul 2013 14:51:30 -0700
Message-Id: <cover.1373922863.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back last year, I posted a largish restructuring of printk.

V1: https://lkml.org/lkml/2012/10/17/41
V2: https://lkml.org/lkml/2012/10/24/748

The idea was to break up this way too large a file into
something more manageable and readable.

This is another posting of just the first few patches of this
series rebased onto v3.11-rc1

If this is acceptable, I'll post 5 or so patches at a time
after/if each block of patches is applied.

Joe Perches (5):
  printk: Move to separate directory for easier modification
  printk: Add console_cmdline.h
  printk: Move braille console support into separate braille.[ch] files
  printk: Use pointer for console_cmdline indexing
  printk: rename struct log to struct printk_log

 drivers/accessibility/braille/braille_console.c |   9 +-
 kernel/Makefile                                 |   3 +-
 kernel/printk/Makefile                          |   2 +
 kernel/printk/braille.c                         |  48 ++++++
 kernel/printk/braille.h                         |  48 ++++++
 kernel/printk/console_cmdline.h                 |  14 ++
 kernel/{ => printk}/printk.c                    | 185 +++++++++++-------------
 7 files changed, 202 insertions(+), 107 deletions(-)
 create mode 100644 kernel/printk/Makefile
 create mode 100644 kernel/printk/braille.c
 create mode 100644 kernel/printk/braille.h
 create mode 100644 kernel/printk/console_cmdline.h
 rename kernel/{ => printk}/printk.c (95%)

-- 
1.8.1.2.459.gbcd45b4.dirty

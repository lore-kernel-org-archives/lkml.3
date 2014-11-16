Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbaKPUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:29 -0500
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:44699 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750699AbaKPUJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:28 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:960:968:973:982:988:989:1260:1345:1359:1431:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3871:3872:3874:4605:5007:6119:6261:6691:7875:7903:8531:8660:10004:10848:11026:11658:11914:12043:12291:12296:12438:12517:12519:12679:12683:13148:13181:13229:13230:14095:14096:14394:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: band97_52679403bdb4c
X-Filterd-Recvd-Size: 3563
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [UNNECESSARY PATCH 00/16] signal: coding style wankery...
Date: Sun, 16 Nov 2014 12:09:07 -0800
Message-Id: <cover.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is intended to be instructive for Ionet Alexa.
All these patches are almost totally unnecessary.

Converting a bunch of issues all at the same time makes for very
difficult reviewing.  Separating the changes into individual
patches can make verifying and accepting the changes easier.

If signal.c was changed just neatening purposes, this is how I
think it should be done.

Even if these patches were applied, there would still checkpatch
messages that are and should be ignored because:

o logic there shouldn't be changed
o 80 column warnings don't have to be fixed
o checkpatch is just a brainless little script

ie:

before the patches:
$ ./scripts/checkpatch.pl -f --strict kernel/signal.c
[...]
total: 53 errors, 99 warnings, 37 checks, 3674 lines checked

after:

$ ./scripts/checkpatch.pl -f --strict kernel/signal.c
WARNING: line over 80 characters
#596: FILE: kernel/signal.c:596:
+				if (!current->notifier(current->notifier_data)) {

WARNING: else is not generally useful after a break or return
#948: FILE: kernel/signal.c:948:
+		return;
+	} else {

CHECK: architecture specific defines should be avoided
#1152: FILE: kernel/signal.c:1152:
+#if defined(__i386__) && !defined(__arch_um__)

CHECK: __setup appears un-documented -- check Documentation/kernel-parameters.txt
#1179: FILE: kernel/signal.c:1179:
+__setup("print-fatal-signals=", setup_print_fatal_signals);

WARNING: line over 80 characters
#1452: FILE: kernel/signal.c:1452:
+				       pid ? find_vpid(-pid) : task_pgrp(current));

WARNING: else is not generally useful after a break or return
#2105: FILE: kernel/signal.c:2105:
+		return true;
+	} else {

WARNING: line over 80 characters
#3753: FILE: kernel/signal.c:3753:
+		kdb_printf("Process is not RUNNING, sending a signal from kdb risks deadlock on the run queue locks. The signal has _not_ been sent.\n"

total: 0 errors, 5 warnings, 2 checks, 3764 lines checked

Joe Perches (16):
  signal: whitespace neatening
  signal: vertical line neatening
  signal: Move EXPORT_SYMBOL after function definition
  signal: Use pr_<level>
  signal: Move case statements to separate lines and for loop neatening
  signal: Use consistent function definition style
  signal: Add braces
  signal: Remove unnecessary return
  signal: Use include <linux not <asm
  signal: Remove unnecessary parentheses from function pointer call
  signal: Add parenthese around sizeof argument
  signal: 80 column wrapping
  signal: Move label to first column
  signal: Convert for (;;) to do {} while
  signal: Isolate returns by adding blank lines
  signal: Coalesce kdb_printf formats

 kernel/signal.c | 528 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 309 insertions(+), 219 deletions(-)

-- 
2.1.2


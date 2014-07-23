Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbaGWPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:34:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52368 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaGWPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:34:21 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] x86_64: LRET to userspace
Date: Wed, 23 Jul 2014 08:34:10 -0700
Message-Id: <cover.1406129131.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on tip/perf/urgent.  It should apply to any
recent kernel, but my test case [1] will OOPS without the fix in
tip/perf/urgent.

The first patch or something like it is needed for 3.16, regardless
of any lret hackery -- I think it's making its way toward a pull
request this week, but I haven't seen it land in -tip yet.

I'm repeating it here because the LRET stuff won't work on paravirt,
and patch 1 puts the machinery for that in place.

tl;dr Read patch 2.  To test, apply patch 1 and consider basing on
tip/perf/urgent.

[1] sigreturn_32 from https://gitorious.org/linux-test-utils/linux-clock-tests/

Andy Lutomirski (2):
  x86_64,entry,xen: Do not invoke espfix64 on Xen
  x86_64,entry: Use lret to return to userspace when possible

 arch/x86/include/asm/irqflags.h     |   3 +-
 arch/x86/include/asm/paravirt.h     |   4 ++
 arch/x86/include/asm/traps.h        |   6 ++
 arch/x86/kernel/cpu/mcheck/mce.c    |   2 +
 arch/x86/kernel/entry_64.S          | 121 ++++++++++++++++++++++++++++++------
 arch/x86/kernel/nmi.c               |  21 +++++++
 arch/x86/kernel/paravirt_patch_64.c |   2 -
 7 files changed, 136 insertions(+), 23 deletions(-)

-- 
1.9.3


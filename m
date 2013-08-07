Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3HGQvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:51:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab3HGQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:51:14 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=lky5M0npDcYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=B5JiVbnoTJEA:10 a=VwQbUJbxAAAA:8 a=MW9TR38vLfj99IOdX0wA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807164934.149920591@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 12:49:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/4] [GIT PULL][3.12] x86/jump-label: Clean ups and safety checks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

These 4 patches were taken from the patchset that did the 2-5 byte
jumps, but had nothing to do with the 2-5 byte jumps itself. They
were clean ups and safety checks that were needed for the jump code.
Although the 2-5 byte jump code is controversial, these cleanups are
not.

The first change is to use the default nops instead of a jmp to next
instruction in the jump label code.

The second is a boot time optimization that doesn't bother changing
the nops if the default nop is the same as the ideal nop.

The third patch adds safety checks like the ftrace function code has.
It makes sure the op code that is being changed is in fact the op code
we expect it to be.

The last patch will output the problem code if it fails the safety
check from patch three.

This is based off of tip/x86/jumplabel, which was equal to v3.11-rc1.

Please pull the latest tip/x86/jumplabel tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/jumplabel

Head SHA1: fb40d7a8994a3cc7a1e1c1f3258ea8662a366916


Steven Rostedt (4):
      x86/jump-label: Use best default nops for inital jump label calls
      x86/jump-label: Do not bother updating nops if they are correct
      x86/jump-label: Add safety checks to jump label conversions
      x86/jump-label: Show where and what was wrong on errors

----
 arch/x86/include/asm/jump_label.h |    9 +++--
 arch/x86/kernel/jump_label.c      |   70 ++++++++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 6 deletions(-)

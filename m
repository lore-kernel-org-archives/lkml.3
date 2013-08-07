Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3HGRlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:41:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20222 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab3HGRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:41:22 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Xxzn6lVSjtQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Bo944viAub8A:10 a=VwQbUJbxAAAA:8 a=uzVaDUB5ZMcsdCqrhOoA:9 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807173606.872055511@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 13:36:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: [RFC][PATCH 0/2] x86/jump labels: Add the 5 byte or 2 byte jumps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said, I would post the patches that let the jmps used by jump labels
be turn to 2 bytes where possible. These are a bit controversial due
to the complexity of the update_jump_label code.

These patches are based off of tip's x86/jumplabel code.

But if someone cares to play with it, feel free. I'll push this up
to my repo under: tip/perf/jump-label-7 (internally this is my 7th version).

I'll post a patch that does the counting as well as a reply to this
post.

Enjoy,

-- Steve


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label-7

Head SHA1: 2a7235814df0cccda60a366fb8b1e5502055ea4d


Steven Rostedt (2):
      jump labels: Add infrastructure to update jump labels at compile time
      x86/jump labels: Use etiher 5 byte or 2 byte jumps

----
 Makefile                          |    7 +
 arch/Kconfig                      |    6 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |    7 +-
 arch/x86/kernel/jump_label.c      |   88 +++++++---
 scripts/Makefile                  |    1 +
 scripts/Makefile.build            |   15 +-
 scripts/update_jump_label.c       |  341 +++++++++++++++++++++++++++++++++++++
 scripts/update_jump_label.h       |  208 ++++++++++++++++++++++
 9 files changed, 649 insertions(+), 25 deletions(-)

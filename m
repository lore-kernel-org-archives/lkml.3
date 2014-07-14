Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaGNRH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:07:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:30956 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756279AbaGNRH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:07:29 -0400
Message-Id: <20140714170506.073521585@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 13:05:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFA][PATCH 0/2] ftrace: Fix arch issues with function graph trampoline
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin,

It was reported to me that my for-next branch broke other archs.
This patch series makes the ftrace graph trampoline an opt-in feature,
as it may require some arch changes to make it work. X86 did not
require changes, but now that it is an opt in, x86 needs to do so
to get this feature.

Can you give me your Acked-by on patch 2?

Thanks!

-- Steve



Steven Rostedt (Red Hat) (2):
      ftrace: Allow archs to specify if they need a separate function graph trampoline
      ftrace/x86: Have function graph tracer use its own trampoline

----
 arch/x86/include/asm/ftrace.h |  2 ++
 include/linux/ftrace.h        | 10 ++++++++++
 kernel/trace/ftrace.c         |  6 ++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

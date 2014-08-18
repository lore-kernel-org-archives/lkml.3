Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaHRLBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaHRLBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:01:12 -0400
Subject: [PATCH 2/2] SH: Fix compilation errors in SH64 signal handling code
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, apkm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Date: Mon, 18 Aug 2014 12:01:05 +0100
Message-ID: <20140818110105.18167.37116.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140818110055.18167.18408.stgit@warthog.procyon.org.uk>
References: <20140818110055.18167.18408.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of compilation errors in SH64 signal handling code.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/sh/kernel/signal_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/signal_64.c b/arch/sh/kernel/signal_64.c
index 897abe7b871e..28448381deb9 100644
--- a/arch/sh/kernel/signal_64.c
+++ b/arch/sh/kernel/signal_64.c
@@ -412,7 +412,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs
 		 * On SH5 all edited pointers are subject to NEFF
 		 */
 		DEREF_REG_PR = neff_sign_extend((unsigned long)
-			ksig->ka->sa.sa_restorer | 0x1);
+			ksig->ka.sa.sa_restorer | 0x1);
 	} else {
 		/*
 		 * Different approach on SH5.
@@ -468,7 +468,7 @@ static int setup_frame(struct ksignal *ksig, sigset_t *set, struct pt_regs *regs
 	return 0;
 }
 
-static int setup_rt_frame(struct ksignal *kig, sigset_t *set,
+static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 			  struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;


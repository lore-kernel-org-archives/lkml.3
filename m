Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaIPTmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:42:40 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:7998 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755150AbaIPTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:42:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMOAIqRGFRXQAMM/2dsb2JhbABggw2BKrQTBQFvmxiBFBcBeYRgI4EaN4hCAbxCGIV8iGtkHYQ1BZ0KjC0EiRSCG4FFOy+BBoFEAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Roland McGrath <roland@hack.frob.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/1 linux-next] ptrace: remove linux/compat.h inclusion under CONFIG_COMPAT
Date: Tue, 16 Sep 2014 21:42:10 +0200
Message-Id: <1410896530-18082-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 84c751bd4aeb
("ptrace: add ability to retrieve signals without removing from a queue (v4)")
includes <linux/compat.h> globally in ptrace.c

This patch removes inclusion under if defined CONFIG_COMPAT.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/ptrace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 54e7522..d4f8e3e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1094,7 +1094,6 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
 }
 
 #if defined CONFIG_COMPAT
-#include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 			  compat_ulong_t addr, compat_ulong_t data)
-- 
2.1.0


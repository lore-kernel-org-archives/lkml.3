Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaL2KVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 05:21:07 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:49285 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbaL2KVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 05:21:03 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgSAKIqoVRXQ5FV/2dsb2JhbABcgwaBKrQkBQEBAQEBAQUBd5cwBAKBDRcBAQEBAX2EaSOBGjeIMAG1fY8CLIYDiRBkHYQTBZcIiWeHaSKBRQGCKT0xgQOBQAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Roland McGrath <roland@hack.frob.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/1 RESEND] ptrace: remove linux/compat.h inclusion under CONFIG_COMPAT
Date: Mon, 29 Dec 2014 11:20:39 +0100
Message-Id: <1419848439-9596-1-git-send-email-fabf@skynet.be>
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
index 1eb9d90..227fec3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1077,7 +1077,6 @@ int generic_ptrace_pokedata(struct task_struct *tsk, unsigned long addr,
 }
 
 #if defined CONFIG_COMPAT
-#include <linux/compat.h>
 
 int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 			  compat_ulong_t addr, compat_ulong_t data)
-- 
2.1.0


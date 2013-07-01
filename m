Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3GAOee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:34:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35877 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3GAOec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:34:32 -0400
From: Dong Fang <yp.fangdong@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: nyc@holomorphy.com, fweisbec@gmail.com, dhowells@redhat.com,
        mchehab@redhat.com, linux-kernel@vger.kernel.org,
        Dong Fang <yp.fangdong@gmail.com>
Subject: [PATCH] kprobes: fix compiler warning
Date: Mon,  1 Jul 2013 10:33:38 -0400
Message-Id: <1372689218-30703-1-git-send-email-yp.fangdong@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compiler warning of uninitialized variable

kernel/kprobes.c: In function ‘register_kprobe’:
kernel/kprobes.c:1493: warning: ‘probed_mod’ may be used uninitialized in this function

Signed-off-by: Dong Fang <yp.fangdong@gmail.com>
---
 kernel/kprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index bddf3b2..7a5b2b1 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1490,7 +1490,7 @@ int __kprobes register_kprobe(struct kprobe *p)
 {
 	int ret;
 	struct kprobe *old_p;
-	struct module *probed_mod;
+	struct module *probed_mod = NULL;
 	kprobe_opcode_t *addr;
 
 	/* Adjust probe address from symbol */
-- 
1.7.1


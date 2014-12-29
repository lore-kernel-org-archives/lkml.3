Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaL2SfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 13:35:07 -0500
Received: from www.osadl.org ([62.245.132.105]:46176 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaL2SfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 13:35:06 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2] gru: cleanup on stack DECLARE_COMPLETION
Date: Mon, 29 Dec 2014 13:31:16 -0500
Message-Id: <1419877876-30308-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix-up for incorrect use of DECLARE_COMPLETION. see also commit
6e9a4738 ("completions: lockdep annotate on stack completions")

V2: split out patch for individual files and (hopefully) proper
    labeling this time

patch is against linux-next 3.19.0-rc1 -next-20141226

patch was compile tested with defconfig_x86_64 + CONFIG_IRQ_REMAP=y
CONFIG_X86_X2APIC=y, CONFIG_X86_UV=y, CONFIG_SGI_GRU=y

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/misc/sgi-gru/grukservices.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 913de07..abf2b73 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -1044,7 +1044,7 @@ done:
 
 static int quicktest2(unsigned long arg)
 {
-	static DECLARE_COMPLETION(cmp);
+	static DECLARE_COMPLETION_ONSTACK(cmp);
 	unsigned long han;
 	int blade_id = 0;
 	int numcb = 4;
-- 
1.7.10.4


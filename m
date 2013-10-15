Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971Ab3JOXWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 19:22:13 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:60989 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab3JOXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 19:22:11 -0400
From: Felipe Pena <felipensp@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH 1/1] drivers: hv: Fix wrong check for synic_event_page
Date: Tue, 15 Oct 2013 20:22:32 -0300
Message-Id: <1381879352-3686-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for calling free_page() on hv_context.synic_event_page[cpu] is the
same for hv_context.synic_message_page[cpu], like a copy-paste error.

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/hv/hv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 88f4096..f0c5e07 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -304,7 +304,7 @@ err:
 void hv_synic_free_cpu(int cpu)
 {
 	kfree(hv_context.event_dpc[cpu]);
-	if (hv_context.synic_message_page[cpu])
+	if (hv_context.synic_event_page[cpu])
 		free_page((unsigned long)hv_context.synic_event_page[cpu]);
 	if (hv_context.synic_message_page[cpu])
 		free_page((unsigned long)hv_context.synic_message_page[cpu]);
-- 
1.7.10.4


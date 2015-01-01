Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbbAARo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:44:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41081 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbAARoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:44:24 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jassi Brar <jassisinghbrar@gmail.com>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] mailbox: pl320-ipc:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:47:24 +0100
Message-Id: <1420134444-388-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
clear_destination() set_destination()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mailbox/pl320-ipc.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index f3755e0..adb969b 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -56,18 +56,6 @@ static DEFINE_MUTEX(ipc_m1_lock);
 static DECLARE_COMPLETION(ipc_completion);
 static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
 
-static inline void set_destination(int source, int mbox)
-{
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
-}
-
-static inline void clear_destination(int source, int mbox)
-{
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
-	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
-}
-
 static void __ipc_send(int mbox, u32 *data)
 {
 	int i;
-- 
1.7.10.4


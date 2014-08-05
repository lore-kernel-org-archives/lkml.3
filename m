Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaHEQvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:51:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:64889 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaHEQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:51:16 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net, oat.elena@gmail.com,
        paulmck@linux.vnet.ibm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Miguel <cmroliv@gmail.com>
Subject: [PATCH] staging: rtl8188eu: Fix static symbol sparse warning
Date: Tue,  5 Aug 2014 19:49:54 +0100
Message-Id: <1407264594-9933-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miguel <cmroliv@gmail.com>

Fix sparse warning:
drivers/staging/rtl8188eu/core/rtw_cmd.c:52:5: warning: symbol '_rtw_enqueue_cmd' was not declared. Should it be static?
by making it static since it's only used once.

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 08c325e..104b01f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -49,7 +49,7 @@ ISR/Call-Back functions can't call this sub-function.
 
 */
 
-int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
+static int _rtw_enqueue_cmd(struct __queue *queue, struct cmd_obj *obj)
 {
 	unsigned long irqL;
 
-- 
1.7.10.4


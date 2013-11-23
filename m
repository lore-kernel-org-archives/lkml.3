Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3KWQbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 11:31:16 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63531 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3KWQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 11:31:13 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>
Subject: [PATCH] usb: hub: avoid possible division by zero
Date: Sat, 23 Nov 2013 17:31:34 +0100
Message-Id: <1385224294-15461-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid possible division by zero in led_work, if hdev->maxchild is 0.

See also:
http://buildbot.llvm.linuxfoundation.org/checker/scan-build-latest/report-b65939.html#EndPath

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/usb/core/hub.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a7c04e2..8c7aa4e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -453,7 +453,8 @@ static void led_work (struct work_struct *work)
 	unsigned		changed = 0;
 	int			cursor = -1;
 
-	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing)
+	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing
+		|| hdev->maxchild == 0)
 		return;
 
 	for (i = 0; i < hdev->maxchild; i++) {
-- 
1.8.4.3


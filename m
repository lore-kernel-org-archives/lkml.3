Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3JHRnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:43:24 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61642 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3JHRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:43:21 -0400
From: Felix Rueegg <felix.rueegg@gmail.com>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Rueegg <felix.rueegg@gmail.com>
Subject: [PATCH] HID: remove self-assignment from hid_input_report
Date: Tue,  8 Oct 2013 19:33:47 +0200
Message-Id: <1381253627-2223-1-git-send-email-felix.rueegg@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ternary expression will always result in a self-assignment, which is pointless.

Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
---
 drivers/hid/hid-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5a8c011..ae0c963 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1417,10 +1417,8 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 
 	if (hdrv && hdrv->raw_event && hid_match_report(hid, report)) {
 		ret = hdrv->raw_event(hid, report, data, size);
-		if (ret < 0) {
-			ret = ret < 0 ? ret : 0;
+		if (ret < 0)
 			goto unlock;
-		}
 	}
 
 	ret = hid_report_raw_event(hid, type, data, size, interrupt);
-- 
1.8.4


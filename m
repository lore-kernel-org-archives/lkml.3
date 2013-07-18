Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3GRNWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:22:40 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:55380 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757344Ab3GRNWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:22:39 -0400
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
To: jkosina@suse.cz
Cc: benjamin.tissoires@gmail.com, adlr@chromium.org,
        joseph.salisbury@canonical.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Subject: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never set
Date: Thu, 18 Jul 2013 06:21:31 -0700
Message-Id: <1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set querying_devices flag to true when we start the enumeration
process.

This was missing from the original patch. It never produced
undesirable effects as it is highly improbable to have a second
enumeration triggered while a first one was still in progress.

Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
---
 drivers/hid/hid-logitech-dj.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 0d13389..d4657a5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -488,6 +488,8 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
 	if (djrcv_dev->querying_devices)
 		return 0;
 
+	djrcv_dev->querying_devices = true;
+
 	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
 	if (!dj_report)
 		return -ENOMEM;
-- 
1.7.9.5


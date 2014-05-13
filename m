Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaEMTPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaEMTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:15:11 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] HID: rmi: fix duplicated argument to && or ||
Date: Tue, 13 May 2014 15:15:01 -0400
Message-Id: <1400008501-7165-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resulted from an unfortunate copy/paste.

Detected automagically by kbuild.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-rmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 7da9509..8a2ad19 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -754,9 +754,9 @@ static void rmi_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	input_set_abs_params(input, ABS_MT_POSITION_X, 1, data->max_x, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 1, data->max_y, 0, 0);
 
-	if (data->x_size_mm && data->x_size_mm) {
+	if (data->x_size_mm && data->y_size_mm) {
 		res_x = (data->max_x - 1) / data->x_size_mm;
-		res_y = (data->max_y - 1) / data->x_size_mm;
+		res_y = (data->max_y - 1) / data->y_size_mm;
 
 		input_abs_set_res(input, ABS_MT_POSITION_X, res_x);
 		input_abs_set_res(input, ABS_MT_POSITION_Y, res_y);
-- 
1.9.0


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbbASUyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbbASUyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:54:11 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 3/6] Input: mt: document input_mt_set_matrix()
Date: Mon, 19 Jan 2015 15:53:52 -0500
Message-Id: <1421700835-22157-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1421700835-22157-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document what the function is about.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/input-mt.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index b269113..0b98ac7 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -337,6 +337,21 @@ static void find_reduced_matrix(int *w, int nr, int nc, int nrc)
 	}
 }
 
+/**
+ * input_mt_set_matrix() - fill the reduced cost matrix for in-kernel tracking
+ * @mt: the input_mt handle of the current device
+ * @pos: the position array to match
+ * @num_pos: number of positions
+ *
+ * Fills the reduced cost matrix by putting in each element the square of the
+ * distance from one of the touch to each elements of the position array to
+ * match.
+ *
+ * The matrix is a reduced one, so it is filled as:
+ * w[i * num_pos + p] == distance(active_slot(i), pos[p])
+ *
+ * Returns the number of elements in the reduced matrix.
+ */
 static int input_mt_set_matrix(struct input_mt *mt,
 			       const struct input_mt_pos *pos, int num_pos)
 {
-- 
2.1.0


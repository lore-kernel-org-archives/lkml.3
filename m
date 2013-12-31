Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3LaTet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:34:49 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34544 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab3LaTer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:34:47 -0500
Date: Tue, 31 Dec 2013 11:34:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Simon Glass <sjg@chromium.org>, Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: cros_ec_keyb - switch from using uint8_t to u8
Message-ID: <20131231193442.GA25208@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u8 is proper in-kernel type for unsigned byte data.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/cros_ec_keyb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index 4083796..d44c5d4 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -50,7 +50,7 @@ struct cros_ec_keyb {
 	int row_shift;
 	const struct matrix_keymap_data *keymap_data;
 	bool ghost_filter;
-	uint8_t *old_kb_state;
+	u8 *old_kb_state;
 
 	struct device *dev;
 	struct input_dev *idev;
@@ -60,7 +60,7 @@ struct cros_ec_keyb {
 
 
 static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
-					  uint8_t *buf, int row)
+					  u8 *buf, int row)
 {
 	int pressed_in_row = 0;
 	int row_has_teeth = 0;
@@ -89,7 +89,7 @@ static bool cros_ec_keyb_row_has_ghosting(struct cros_ec_keyb *ckdev,
  * Returns true when there is at least one combination of pressed keys that
  * results in ghosting.
  */
-static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, uint8_t *buf)
+static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, u8 *buf)
 {
 	int row;
 
@@ -132,7 +132,7 @@ static bool cros_ec_keyb_has_ghosting(struct cros_ec_keyb *ckdev, uint8_t *buf)
  * per column)
  */
 static void cros_ec_keyb_process(struct cros_ec_keyb *ckdev,
-			 uint8_t *kb_state, int len)
+				 u8 *kb_state, int len)
 {
 	struct input_dev *idev = ckdev->idev;
 	int col, row;
@@ -189,19 +189,19 @@ static void cros_ec_keyb_close(struct input_dev *dev)
 					   &ckdev->notifier);
 }
 
-static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, uint8_t *kb_state)
+static int cros_ec_keyb_get_state(struct cros_ec_keyb *ckdev, u8 *kb_state)
 {
 	return ckdev->ec->command_recv(ckdev->ec, EC_CMD_MKBP_STATE,
 					  kb_state, ckdev->cols);
 }
 
 static int cros_ec_keyb_work(struct notifier_block *nb,
-		     unsigned long state, void *_notify)
+			     unsigned long state, void *_notify)
 {
 	int ret;
 	struct cros_ec_keyb *ckdev = container_of(nb, struct cros_ec_keyb,
 						    notifier);
-	uint8_t kb_state[ckdev->cols];
+	u8 kb_state[ckdev->cols];
 
 	ret = cros_ec_keyb_get_state(ckdev, kb_state);
 	if (ret >= 0)
@@ -282,8 +282,8 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
 /* Clear any keys in the buffer */
 static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
 {
-	uint8_t old_state[ckdev->cols];
-	uint8_t new_state[ckdev->cols];
+	u8 old_state[ckdev->cols];
+	u8 new_state[ckdev->cols];
 	unsigned long duration;
 	int i, ret;
 
-- 
1.8.3.1


-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3APQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab3APQJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christophe TORDEUX <christophe@tordeux.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 193/222] Input: sentelic - only report position of first finger as ST coordinates
Date: Wed, 16 Jan 2013 13:56:33 -0200
Message-Id: <1358351822-7675-194-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe TORDEUX <christophe@tordeux.net>

commit a25461659050b913e114d282bf58823682eb56b6 upstream.

Report only the position of the first finger as absolute non-MT coordinates,
instead of reporting both fingers alternatively. Actual MT events are
unaffected.

This fixes horizontal and improves vertical scrolling with the touchpad.

Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/mouse/sentelic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 3f5649f..bb74867 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -780,7 +780,7 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
 			fsp_set_slot(dev, 1, false, 0, 0);
 		}
-		if (fgrs > 0) {
+		if (fgrs == 1 || (fgrs == 2 && !(packet[0] & FSP_PB0_MFMC_FGR2))) {
 			input_report_abs(dev, ABS_X, abs_x);
 			input_report_abs(dev, ABS_Y, abs_y);
 		}
-- 
1.7.9.5


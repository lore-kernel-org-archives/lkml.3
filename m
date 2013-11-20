Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab3KTVdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:33:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab3KTVcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:32:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Antonio Ospite <ospite@studenti.unina.it>, simon@mungewell.org,
        case@corpsmoderne.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Only process ABS_MT_SLOT where there are slots available
Date: Wed, 20 Nov 2013 16:32:19 -0500
Message-Id: <1384983141-31019-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1384983141-31019-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antonio Ospite <ospite@studenti.unina.it>

This fixes the case when a non-multitouch device happens to have a HID
code equal to ABS_MT_SLOT, like the Sony Sixaxis has for the left dpad
analog control.

Updated to latest tree by Benjamin Tissoires.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

This patch was sent back in 2011 by Antonio and it was forgotten in the depth
of the LKML:
http://www.spinics.net/lists/linux-input/msg16881.html
Resurecting it now, as the bug is still there.

Antonio, could you please tell me if you still add your Signed-of-by line and
if I can keep your from?

Cheers,
Benjamin
drivers/input/input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index fb513da..1198785 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -213,12 +213,12 @@ static int input_handle_abs_event(struct input_dev *dev,
 	bool is_mt_event;
 	int *pold;
 
-	if (code == ABS_MT_SLOT) {
+	if (code == ABS_MT_SLOT && mt) {
 		/*
 		 * "Stage" the event; we'll flush it later, when we
 		 * get actual touch data.
 		 */
-		if (mt && *pval >= 0 && *pval < mt->num_slots)
+		if (*pval >= 0 && *pval < mt->num_slots)
 			mt->slot = *pval;
 
 		return INPUT_IGNORE_EVENT;
-- 
1.8.3.1


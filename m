Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab3AWWg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:36:28 -0500
Received: from mailserver6.natinst.com ([130.164.80.6]:51024 "EHLO
	spamkiller06.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3AWWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:36:21 -0500
From: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Karthik Manamcheri <Karthik.Manamcheri@ni.com>
Subject: [PATCH] n_tty: Unthrottle tty when flushing read buffer
Date: Wed, 23 Jan 2013 16:36:18 -0600
Message-Id: <1358980578-8811-1-git-send-email-Karthik.Manamcheri@ni.com>
X-Mailer: git-send-email 1.8.1.1
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 01/23/2013 04:36:20 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 01/23/2013 04:36:20 PM,
	Serialize complete at 01/23/2013 04:36:20 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2013-01-23_07:2013-01-23,2013-01-23,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the tty input buffer is full and thereby throttled,
flushing/resetting the read buffer should unthrottle to allow more
data to be received.

Signed-off-by: Karthik Manamcheri <Karthik.Manamcheri@ni.com>
---
 drivers/tty/n_tty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 19083efa2314660b25e0fb5bc793af6fb7e9af57..d5cea3bb01eaeec61b577de6c58a8000412c0c37 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -229,6 +229,8 @@ static void reset_buffer_flags(struct tty_struct *tty)
 	ldata->canon_head = ldata->canon_data = ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 	n_tty_set_room(tty);
+
+	check_unthrottle(tty);
 }
 
 /**
-- 
1.8.1.1


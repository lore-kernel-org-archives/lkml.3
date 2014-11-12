Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbaKLECq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:02:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbaKLBYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andreas Bosch <linux@progandy.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.17 101/319] Input: alps - fix v4 button press recognition
Date: Wed, 12 Nov 2014 10:13:59 +0900
Message-Id: <20141112011009.296839177@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bosch <linux@progandy.de>

commit b0cfb794a3dd1d699f3e453f9180bd06508fb8f0 upstream.

Since the change to struct input_mt_pos some variables are now bitfields
instead of integers. Automatic conversion from integer to bitfield entry
destroys information, therefore enforce boolean interpretation instead.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=1114768
Fixes: 02d04254a5df ("Input: alps - use struct input_mt_pos to track coordinates")
Signed-off-by: Andreas Bosch <linux@progandy.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -835,8 +835,8 @@ static void alps_process_packet_v4(struc
 		f->fingers = alps_process_bitmap(priv, f);
 	}
 
-	f->left = packet[4] & 0x01;
-	f->right = packet[4] & 0x02;
+	f->left = !!(packet[4] & 0x01);
+	f->right = !!(packet[4] & 0x02);
 
 	f->st.x = ((packet[1] & 0x7f) << 4) | ((packet[3] & 0x30) >> 2) |
 		  ((packet[0] & 0x30) >> 4);



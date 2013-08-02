Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3HBLE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:04:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18945 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3HBLE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:04:26 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: ozwpan: Fix farewell report.
Date: Fri, 2 Aug 2013 12:04:16 +0100
Message-ID: <1375441456-20415-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <51FB915C.1050003@atmel.com>
References: <51FB915C.1050003@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes issues reported by Dan here:-
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2013-August/040052.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.h    |    2 +-
 drivers/staging/ozwpan/ozproto.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index 57e98c8..996ef65 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -48,8 +48,8 @@ struct oz_farewell {
 	struct list_head link;
 	u8 ep_num;
 	u8 index;
-	u8 report[32];
 	u8 len;
+	u8 report[0];
 };
 
 /* Data structure that holds information on a specific peripheral device (PD).
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 084307a..3d1a89f 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -291,7 +291,7 @@ static void oz_add_farewell(struct oz_pd *pd, u8 ep_num, u8 index,
 	struct oz_farewell *f;
 	struct oz_farewell *f2;
 	int found = 0;
-	f = kmalloc(sizeof(struct oz_farewell) + len - 1, GFP_ATOMIC);
+	f = kmalloc(sizeof(struct oz_farewell) + len, GFP_ATOMIC);
 	if (!f)
 		return;
 	f->ep_num = ep_num;
-- 
1.7.9.5


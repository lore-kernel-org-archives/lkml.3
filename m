Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3KJUZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 15:25:04 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50337 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3KJUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 15:24:58 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] staging: go7007: fix use of uninitialised pointer
In-Reply-To: <20131110185210.GA9633@kroah.com>
References: <1384108677-23476-1-git-send-email-mpn@google.com> <20131110185210.GA9633@kroah.com>
User-Agent: Notmuch/0.16+80~g81ee785 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Sun, 10 Nov 2013 21:24:54 +0100
Message-ID: <87fvr480o9.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/media/go7007/go7007-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

On Sun, Nov 10 2013, Greg Kroah-Hartman wrote:
> Please either delete this entirely, or use the struct device in the
> usb_interface pointer.
>
> A driver should never have a "raw" pr_* call.

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..e8c708c 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	dev_dbg(&intf->dev, "probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
-- 
1.8.3.2

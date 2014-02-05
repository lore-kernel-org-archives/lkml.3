Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaBEUHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:18 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48454 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaBEUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sven Schnelle <svens@stackframe.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 150/213] USB: CDC ACM: Fix NULL pointer dereference
Date: Wed, 5 Feb 2014 15:01:45 -0500
Message-ID: <1391630568-49251-151-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 99f347caa4568cb803862730b3b1f1942639523f upstream.

If a device specifies zero endpoints in its interface descriptor,
the kernel oopses in acm_probe(). Even though that's clearly an
invalid descriptor, we should test wether we have all endpoints.
This is especially bad as this oops can be triggered by just
plugging a USB device in.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index af45f735f6e5..45f85df306e5 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1120,7 +1120,8 @@ skip_normal_probe:
 	}
 
 
-	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2)
+	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2 ||
+	    control_interface->cur_altsetting->desc.bNumEndpoints == 0)
 		return -EINVAL;
 
 	epctrl = &control_interface->cur_altsetting->endpoint[0].desc;
-- 
1.8.5.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaBEUce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:32:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:55249 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098AbaBEUHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:00 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 145/213] USB: mos7840: fix port-device leak in error path
Date: Wed, 5 Feb 2014 15:01:40 -0500
Message-ID: <1391630568-49251-146-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3eb55cc4ed88eee3b5230f66abcdbd2a91639eda upstream.

The driver set the usb-serial port pointers to NULL on errors in attach,
effectively preventing usb-serial core from decrementing the port ref
counters and releasing the port devices and associated data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/mos7840.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index d891d44501f8..c55d2aa35eaa 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2565,7 +2565,6 @@ error:
 		kfree(mos7840_port->ctrl_buf);
 		usb_free_urb(mos7840_port->control_urb);
 		kfree(mos7840_port);
-		serial->port[i] = NULL;
 	}
 	return status;
 }
-- 
1.8.5.2


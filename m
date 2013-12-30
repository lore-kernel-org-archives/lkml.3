Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3L3DMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 22:12:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41845 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3L3DMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 22:12:05 -0500
Date: Mon, 30 Dec 2013 11:11:02 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: [PATCH] vt: initialize con_driver->node in con_init
Message-ID: <20131230031102.GA4424@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, airlied@redhat.com,
	akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6db4063c5b72b46e9793b0f141a7a3984ac6facf
("[PATCH] VT binding: Add sysfs control to the VT layer")
add node item into struct con_driver.

This patch initialize con_driver->node in con_init.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index edcd6b8..9adb4e0 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2879,6 +2879,7 @@ static int __init con_init(void)
 		if (con_driver->con == NULL) {
 			con_driver->con = conswitchp;
 			con_driver->desc = display_desc;
+			con_driver->node = i;
 			con_driver->flag = CON_DRIVER_FLAG_INIT;
 			con_driver->first = 0;
 			con_driver->last = MAX_NR_CONSOLES - 1;
-- 
1.8.3.4.8.g69490f3.dirty

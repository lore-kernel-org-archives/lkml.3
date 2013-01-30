Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3A3RrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:47:04 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33595 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756075Ab3A3RqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:46:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 3/4] tty: Document required behavior of tty driver close()
Date: Wed, 30 Jan 2013 12:43:51 -0500
Message-Id: <1359567832-25318-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
References: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the tty driver open() fails, the tty driver close() is still
called during the resultant tty release.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty_driver.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index dd976cf..756a609 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -40,6 +40,7 @@
  * void (*close)(struct tty_struct * tty, struct file * filp);
  *
  * 	This routine is called when a particular tty device is closed.
+ *	Note: called even if the corresponding open() failed.
  *
  *	Required method.
  *
-- 
1.8.1.1


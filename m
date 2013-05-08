Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3EHSOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54709 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3EHSOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:38 -0400
Date: Thu, 9 May 2013 02:14:29 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] vt: delete unneeded function bind_con_driver
Message-ID: <20130508181429.GH12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no place use bind_con_driver,
and do_bind_con_driver can achieve bind_con_driver's
function easily, so just delete it to reduce code size and
duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 7e0953c..d5bfa86 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3088,17 +3088,6 @@ err:
 };
 
 
-static int bind_con_driver(const struct consw *csw, int first, int last,
-			   int deflt)
-{
-	int ret;
-
-	console_lock();
-	ret = do_bind_con_driver(csw, first, last, deflt);
-	console_unlock();
-	return ret;
-}
-
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
 {
-- 
1.7.12.4.dirty

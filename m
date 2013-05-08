Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab3EHSOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:22 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:40622 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab3EHSOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:20 -0400
Date: Thu, 9 May 2013 02:14:07 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] vt: convert last unbind_con_driver call to
 do_unbind_con_driver
Message-ID: <20130508181407.GE12344@udknight>
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

There is only one place use unbind_con_driver, this patch
convert it to do_unbind_con_driver too, then we can delete
unbind_con_driver to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 852d470..a422322 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3303,8 +3303,11 @@ static int vt_unbind(struct con_driver *con)
 		if (first == 0 && last == MAX_NR_CONSOLES -1)
 			deflt = 1;
 
-		if (first != -1)
-			unbind_con_driver(csw, first, last, deflt);
+		if (first != -1) {
+			console_lock();
+			do_unbind_con_driver(csw, first, last, deflt);
+			console_unlock();
+		}
 
 		first = -1;
 		last = -1;
-- 
1.7.12.4.dirty

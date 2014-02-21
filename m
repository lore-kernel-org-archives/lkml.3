Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876AbaBUM5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:57:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaBUMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <petr.pisar@atlas.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 106/121] vt: Fix secure clear screen
Date: Fri, 21 Feb 2014 12:48:50 +0000
Message-Id: <1392986945-9693-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <petr.pisar@atlas.cz>

commit 0930b0950a8996aa88b0d2ba4bb2bab27cc36bc7 upstream.

\E[3J console code (secure clear screen) needs to update_screen(vc)
in order to write-through blanks into off-screen video memory.

This has been removed accidentally in 3.6 by:

commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
Author: Jean-François Moine <moinejf@free.fr>
Date:   Thu Sep 6 19:24:13 2012 +0200

    tty vt: Fix line garbage in virtual console on command line edition

Signed-off-by: Petr Písař <petr.pisar@atlas.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/vt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c677829..7a35647 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1164,6 +1164,8 @@ static void csi_J(struct vc_data *vc, int vpar)
 			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
 				    vc->vc_screenbuf_size >> 1);
 			set_origin(vc);
+			if (CON_IS_VISIBLE(vc))
+				update_screen(vc);
 			/* fall through */
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
-- 
1.9.0


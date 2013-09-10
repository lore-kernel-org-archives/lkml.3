Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3IJWNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:13:46 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:49858 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3IJWNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:13:45 -0400
X-Greylist: delayed 2315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2013 18:13:44 EDT
In-Reply-To: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
References: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
From: Adam Borowski <kilobyte@angband.pl>
Date: Tue, 10 Sep 2013 22:54:35 +0200
Subject: [PATCH 1/2] vt: break a couple of obsolete SCOish codes.
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-Id: <E1VJVaS-0001eY-F7@tartarus.angband.pl>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: c6de2745000038bf355d23aefca8311624b05823@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No modern terminal supports them, and SGR 38 conflicts with detecting
xterm-256 colours.  This also makes SGR 39 consistent with other popular
terminals.  Neither are used by ncurses' terminfo.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/tty/vt/vt.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c677829..ba528bb 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1300,21 +1300,8 @@ static void csi_m(struct vc_data *vc)
 			case 27:
 				vc->vc_reverse = 0;
 				break;
-			case 38: /* ANSI X3.64-1979 (SCO-ish?)
-				  * Enables underscore, white foreground
-				  * with white underscore (Linux - use
-				  * default foreground).
-				  */
-				vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
-				vc->vc_underline = 1;
-				break;
-			case 39: /* ANSI X3.64-1979 (SCO-ish?)
-				  * Disable underline option.
-				  * Reset colour to default? It did this
-				  * before...
-				  */
+			case 39:
 				vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
-				vc->vc_underline = 0;
 				break;
 			case 49:
 				vc->vc_color = (vc->vc_def_color & 0xf0) | (vc->vc_color & 0x0f);
-- 
1.7.10.4


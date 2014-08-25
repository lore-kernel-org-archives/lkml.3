Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbaHYSai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 14:30:38 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54535 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaHYSah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 14:30:37 -0400
Date: Mon, 25 Aug 2014 11:30:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: ALPS - suppress message about 'Unknown touchpad'
Message-ID: <20140825183031.GA5151@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to match data returned by E7 and EC reports we state that we
found "Unknown ALPS touchpad" whereas it is most likely it is not ALPS
touchpad at all. Change wording a bit and reduce the message to debug so
that it does not litter users logs and confuse them.

Reported-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/mouse/alps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index a59a1a6..a956b98 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2234,8 +2234,8 @@ static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 		return 0;
 	}
 
-	psmouse_info(psmouse,
-		     "Unknown ALPS touchpad: E7=%3ph, EC=%3ph\n", e7, ec);
+	psmouse_dbg(psmouse,
+		    "Likely not an ALPS touchpad: E7=%3ph, EC=%3ph\n", e7, ec);
 
 	return -EINVAL;
 }
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry

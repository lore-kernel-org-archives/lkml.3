Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3LUKOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:14:24 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46361 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:14:23 -0500
Date: Sat, 21 Dec 2013 15:44:13 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Martin Berglund <martin@rogsta.net>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>,
        devel@driverdev.osuosl.org, josh@joshtriplett.org
Subject: [PATCH] drivers: sm7xxfb: Mark function as static in sm7xxfb.c
Message-ID: <20131221101413.GA2946@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function smtcfb_setmode() as static in sm7xxfb.c because it is not
used outside this file.

This eliminates the following warning in sm7xxfb.c:
drivers/staging/sm7xxfb/sm7xxfb.c:588:6: warning: no previous prototype for ‘smtcfb_setmode’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm7xxfb.c
index ba199ff..f08b216 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -585,7 +585,7 @@ static void smtc_set_timing(struct smtcfb_info *sfb)
 	}
 }
 
-void smtcfb_setmode(struct smtcfb_info *sfb)
+static void smtcfb_setmode(struct smtcfb_info *sfb)
 {
 	switch (sfb->fb.var.bits_per_pixel) {
 	case 32:
-- 
1.7.9.5


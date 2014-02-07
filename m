Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaBGMie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:38:34 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42308 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbaBGMia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:38:30 -0500
Date: Fri, 7 Feb 2014 18:08:23 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 16/26] drivers: isdn: Move prototype declarations to
 appropriate header file hscx.h from elsa_ser.c
Message-ID: <e32c0193b53196909f461a3f54cd8c196619b696.1390408517.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of functions to header file hisax/hscx.h
because they are used by more than one file.

This eliminates the following warnings in hisax/hscx.c:
drivers/isdn/hisax/hscx.c:96:1: warning: no previous prototype for ‘hscx_l2l1’ [-Wmissing-prototypes]
drivers/isdn/hisax/hscx.c:175:1: warning: no previous prototype for ‘open_hscxstate’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hisax/elsa_ser.c |    2 --
 drivers/isdn/hisax/hscx.h     |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hisax/elsa_ser.c b/drivers/isdn/hisax/elsa_ser.c
index 3f84dd8..0d5ccd2 100644
--- a/drivers/isdn/hisax/elsa_ser.c
+++ b/drivers/isdn/hisax/elsa_ser.c
@@ -419,9 +419,7 @@ static void rs_interrupt_elsa(struct IsdnCardState *cs)
 #endif
 }
 
-extern int open_hscxstate(struct IsdnCardState *cs, struct BCState *bcs);
 extern void modehscx(struct BCState *bcs, int mode, int bc);
-extern void hscx_l2l1(struct PStack *st, int pr, void *arg);
 
 static void
 close_elsastate(struct BCState *bcs)
diff --git a/drivers/isdn/hisax/hscx.h b/drivers/isdn/hisax/hscx.h
index 1148b4b..e99db24 100644
--- a/drivers/isdn/hisax/hscx.h
+++ b/drivers/isdn/hisax/hscx.h
@@ -39,3 +39,5 @@ extern void modehscx(struct BCState *bcs, int mode, int bc);
 extern void clear_pending_hscx_ints(struct IsdnCardState *cs);
 extern void inithscx(struct IsdnCardState *cs);
 extern void inithscxisac(struct IsdnCardState *cs, int part);
+extern void hscx_l2l1(struct PStack *st, int pr, void *arg);
+extern int open_hscxstate(struct IsdnCardState *cs, struct BCState *bcs);
-- 
1.7.9.5


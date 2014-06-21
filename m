Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaFUR3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 13:29:43 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53900 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaFUR3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 13:29:42 -0400
Date: Sat, 21 Jun 2014 19:29:35 +0200
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: cxt1e1: fix sbeCrc function declaration
Message-ID: <20140621172931.GA13116@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the following sparse warning:

drivers/staging/cxt1e1/sbecrc.c:86:1: warning: symbol 'sbeCrc' was not declared. Should it be static?

Furthermore it fixes wring sbeCrc return type in function declaration.

Regards
Pawel Lebioda

Signed-off-by: Pawel Lebioda <pawel.lebioda89@gmail.com>
---
 drivers/staging/cxt1e1/pmcc4.h         | 2 +-
 drivers/staging/cxt1e1/pmcc4_private.h | 1 +
 drivers/staging/cxt1e1/sbecrc.c        | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
index b4b5e5a..0220bbf 100644
--- a/drivers/staging/cxt1e1/pmcc4.h
+++ b/drivers/staging/cxt1e1/pmcc4.h
@@ -94,7 +94,7 @@ void        sbecom_set_loglevel (int debuglevel);
 char       *sbeid_get_bdname (ci_t *ci);
 void        sbeid_set_bdtype (ci_t *ci);
 void        sbeid_set_hdwbid (ci_t *ci);
-u_int32_t   sbeCrc (u_int8_t *, u_int32_t, u_int32_t, u_int32_t *);
+void        sbeCrc(u_int8_t *, u_int32_t, u_int32_t, u_int32_t *);
 
 void        VMETRO_TRIGGER (ci_t *, int);       /* Note: int = 0(default)
                                                  * thru 15 */
diff --git a/drivers/staging/cxt1e1/pmcc4_private.h b/drivers/staging/cxt1e1/pmcc4_private.h
index 451f12f..134ddd6 100644
--- a/drivers/staging/cxt1e1/pmcc4_private.h
+++ b/drivers/staging/cxt1e1/pmcc4_private.h
@@ -33,6 +33,7 @@
 #include "musycc.h"
 #include "sbe_promformat.h"
 #include "comet.h"
+#include "sbecom_inline_linux.h"
 
 
 /* driver state */
diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index a51780f..52d3f71 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/types.h>
+#include "pmcc4.h"
 #include "pmcc4_sysdep.h"
 #include "sbecom_inline_linux.h"
 #include "sbe_promformat.h"

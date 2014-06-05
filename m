Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFEUtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:49:05 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:60845 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaFEUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:49:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Henk de Groot <pe1dnn@amsat.org>
Subject: [PATCH 4/5] staging: wlags49_h2: avoid PROFILE_ALL_BRANCHES warnings
Date: Thu,  5 Jun 2014 22:48:14 +0200
Message-Id: <1402001295-1980118-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1KQrXpaL3NbmVfyD2wJ4LfTwoPHTm3MsKzFrG4wWVgn
 HGXmx3ZjQJE/0yvxcT55fSrhIK7Tj5eTlym9Em5Tk6li314V1J
 8kHC6ri+czghceZSpQ37Q4Cq8VhtsfyLCstLVOlMmGg5paDbRS
 5nCN9jNTA0d1KDRl/S7tXQXWbl0XSUWCoZmpa/o1g8m+MTvlFo
 pX6izscw6NszJQHqQnKTChF0BSgAkivD9UNyskVaCVDeJvbGEq
 iowOhWsvLaDYcTrWpA4/VdglKroykPLj4cR+PGrdnYeuOmHNNo
 gFz0nbNV10Kx2b5RQZZRBAge40JnwyVgFi0BqIaYNw2KrBpKwQ
 zmsXNs7XyTqIzdUXdhlzwAwow64RvWUYjoobRN8wt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using an 'if()' inside of an 'extern inline' function causes
a gcc warning when CONFIG_PROFILE_ALL_BRANCHES is set every
time the function is called, which gets very noisy:

In file included from /git/arm-soc/drivers/staging/wlags49_h2/wl_wext.c:73:0:
drivers/staging/wlags49_h2/wl_internal.h:1035:216: warning: '______f' is static but declared in inline function 'wl_act_int_off' which is not static [enabled by default]
  if(lp->is_handling_int == WL_HANDLING_INT) {

Fortunately there is a trivial workaround, so we can avoid
the problem by making the functions in question 'static inline'
rather than 'extern inline'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Henk de Groot <pe1dnn@amsat.org>
---
 drivers/staging/wlags49_h2/wl_internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_internal.h b/drivers/staging/wlags49_h2/wl_internal.h
index 78129e9..1ecb5cb 100644
--- a/drivers/staging/wlags49_h2/wl_internal.h
+++ b/drivers/staging/wlags49_h2/wl_internal.h
@@ -1013,7 +1013,7 @@ static inline void wl_unlock(struct wl_private *lp,
 /* Interrupt enable disable functions                               */
 /********************************************************************/
 
-extern inline void wl_act_int_on(struct wl_private *lp)
+static inline void wl_act_int_on(struct wl_private *lp)
 {
 	/*
 	 * Only do something when the driver is handling
@@ -1025,7 +1025,7 @@ extern inline void wl_act_int_on(struct wl_private *lp)
 	}
 }
 
-extern inline void wl_act_int_off(struct wl_private *lp)
+static inline void wl_act_int_off(struct wl_private *lp)
 {
 	/*
 	 * Only do something when the driver is handling
-- 
1.8.3.2


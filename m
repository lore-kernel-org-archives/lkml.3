Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaEVS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:57:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40963 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaEVS5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:57:40 -0400
Date: Thu, 22 May 2014 11:57:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jingoo Han <jg1.han@samsung.com>, devel@driverdev.osuosl.org
Subject: [PATCH] staging/rtl8821ae: avoid format string leak to thread name
Message-ID: <20140522185716.GA8796@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure the cfg->name can never accidentally be processed as a
format string in the worker thread name.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/rtl8821ae/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
index a4c9cc437bc6..49ee311ddcd9 100644
--- a/drivers/staging/rtl8821ae/base.c
+++ b/drivers/staging/rtl8821ae/base.c
@@ -404,7 +404,8 @@ static int _rtl_init_deferred_work(struct ieee80211_hw *hw)
 /*<delete in kernel start>*/
 #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 37))
 /*<delete in kernel end>*/
-	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
+	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0,
+						rtlpriv->cfg->name);
 /*<delete in kernel start>*/
 #else
 	rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

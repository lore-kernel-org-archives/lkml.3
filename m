Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaD1C04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:26:56 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51641 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaD1C0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:26:43 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Liang Zhen <liang.zhen@intel.com>
Subject: [PATCH v3 4/4] staging/lustre/lnet: fix potential null pointer dereference
Date: Sun, 27 Apr 2014 22:25:58 -0400
Message-Id: <1398651958-5103-5-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398651958-5103-1-git-send-email-green@linuxhacker.ru>
References: <1398651958-5103-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointer 'ni' checked for NULL at line 1569 may be passed to
function and may be dereferenced there by passing argument 1 to
function 'lnet_ni_notify_locked' at line 1621.
found by Klocwork Insight tool

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
CC: Dmitry Eremin <dmitry.eremin@intel.com>
CC: Liang Zhen <liang.zhen@intel.com>
---
 drivers/staging/lustre/lnet/lnet/router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 995f509..926923a 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -145,7 +145,7 @@ lnet_ni_notify_locked(lnet_ni_t *ni, lnet_peer_t *lp)
 	 * NB individual events can be missed; the only guarantee is that you
 	 * always get the most recent news */
 
-	if (lp->lp_notifying)
+	if (lp->lp_notifying || ni == NULL)
 		return;
 
 	lp->lp_notifying = 1;
-- 
1.9.0


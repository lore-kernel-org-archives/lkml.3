Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3LKQnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:43:49 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:42928 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3LKQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:43:43 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>, Peter Stuge <peter@stuge.se>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] net: wirelesse: wcn36xx: pull allocation outside of critical
 section
In-Reply-To: <20131211155249.GD7411@tuxdriver.com>
Organization: http://mina86.com/
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se> <xa1tiov78kmp.fsf@mina86.com> <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com> <878uvw1t49.fsf@mina86.com> <CAFSJ42a5ngsShaQPwwjfLxaj3ojvghwTAvCBggG=tPr9oLwhEg@mail.gmail.com> <8738m2uukz.fsf@mina86.com> <20131211155249.GD7411@tuxdriver.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131211:ath9k-devel@venema.h4ckr.net::pOUJOCR3yWehaUA8:0000000000000000000000000000000000xWZ
X-Hashcash: 1:20:131211:k.eugene.e@gmail.com::trM0/KrDCaDfnNwO:000000000000000000000000000000000000000000uvA
X-Hashcash: 1:20:131211:linux-wireless@vger.kernel.org::6jpZO+MEq2ZYyMBF:000000000000000000000000000000039sq
X-Hashcash: 1:20:131211:linux-kernel@vger.kernel.org::cPDY92yj0syjNEoq:00000000000000000000000000000000044DI
X-Hashcash: 1:20:131211:linville@tuxdriver.com::23zdIxlm20zQ//dA:0000000000000000000000000000000000000004Or6
X-Hashcash: 1:20:131211:peter@stuge.se::rhGJ7T5bpOESLyMl:000A4yc
Date: Wed, 11 Dec 2013 17:43:39 +0100
Message-ID: <xa1tbo0nqqx0.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit [3469adb3: fix potential NULL pointer dereference] introduced
a check of msg_ind allocation, but omitted allocation of msg_ind->msg.
Moreover, it introduced two if statements, which looked a bit clunky.

This commit moves allocation code outside of the critical section so
there's no need to dance around mutex_unlock, and adds the missing
allocation check.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

On Wed, Dec 11 2013, John W. Linville wrote:
> Missing Signed-off-by...

Sorry about that.

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 8f37562..750626b 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2060,22 +2060,28 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
-		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
-		if (msg_ind) {
-			msg_ind->msg_len = len;
-			msg_ind->msg = kmalloc(len, GFP_KERNEL);
-			memcpy(msg_ind->msg, buf, len);
-			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
-			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
-			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (!msg_ind)
+			goto nomem;
+		msg_ind->msg_len = len;
+		msg_ind->msg = kmalloc(len, GFP_KERNEL);
+		if (!msg_ind->msg) {
+			kfree(msg_ind);
+nomem:
+			/*
+			 * FIXME: Do something smarter then just
+			 * printing an error.
+			 */
+			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+				    msg_header->msg_type);
+			break;
 		}
+		memcpy(msg_ind->msg, buf, len);
+		mutex_lock(&wcn->hal_ind_mutex);
+		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
 		mutex_unlock(&wcn->hal_ind_mutex);
-		if (msg_ind)
-			break;
-		/* FIXME: Do something smarter then just printing an error. */
-		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
-			    msg_header->msg_type);
+		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4


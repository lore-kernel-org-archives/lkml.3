Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaEUTKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:10:11 -0400
Received: from mout.gmx.net ([212.227.17.21]:60972 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaEUTKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:10:10 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: isdn@linux-pingi.de
Cc: manuel.schoelling@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mISDN: Use time_before()
Date: Wed, 21 May 2014 21:10:05 +0200
Message-Id: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:u8qNu+EekcEyP1lXkXrfijFYjNmmRbaRYLRO8OGR7xFvkDIHghz
 CxrdN0rr3/DDrIPdKbWwkssJaBMa9hG1NmK/zpqPzmptYHjZ50MDkV2dD6IdcjPWn49ENVL
 plMb1gpRhOB5F2HH6e/KX59PvhzcPhcoZKMJccqEA4k75we1IVHAcmgRioguy10FFZu4bhp
 lzDmMhiT7Vj9LcvHgayHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are modified
to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/isdn/mISDN/l1oip_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 2c0d2c2..1c2bc36 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -287,7 +287,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if ((int)(hc->keep_tl.expires-jiffies) < 5 * HZ) {
+	if (time_before(hc->keep_tl.expires - 5 * HZ, jiffies)) {
 		del_timer(&hc->keep_tl);
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
 		add_timer(&hc->keep_tl);
@@ -621,7 +621,8 @@ multiframe:
 		goto multiframe;
 
 	/* restart timer */
-	if ((int)(hc->timeout_tl.expires-jiffies) < 5 * HZ || !hc->timeout_on) {
+	if (time_before(hc->timeout_tl.expires - 5 * HZ, jiffies)
+	    || !hc->timeout_on) {
 		hc->timeout_on = 1;
 		del_timer(&hc->timeout_tl);
 		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT * HZ;
-- 
1.7.10.4


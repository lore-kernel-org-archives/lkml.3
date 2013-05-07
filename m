Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946Ab3EGNwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:52:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759435Ab3EGNmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 101/118] gianfar: do not advertise any alarm capability.
Date: Tue,  7 May 2013 14:39:07 +0100
Message-Id: <1367933964-1564-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

commit cd4baaaa04b4aaa3b0ec4d13a6f3d203b92eadbd upstream.

An early draft of the PHC patch series included an alarm in the
gianfar driver. During the review process, the alarm code was dropped,
but the capability removal was overlooked. This patch fixes the issue
by advertising zero alarms.

This patch should be applied to every 3.x stable kernel.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reported-by: Chris LaRocque <clarocq@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/freescale/gianfar_ptp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index 0daa66b..d81c7af 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -127,7 +127,6 @@ struct gianfar_ptp_registers {
 
 #define DRIVER		"gianfar_ptp"
 #define DEFAULT_CKSEL	1
-#define N_ALARM		1 /* first alarm is used internally to reset fipers */
 #define N_EXT_TS	2
 #define REG_SIZE	sizeof(struct gianfar_ptp_registers)
 
@@ -410,7 +409,7 @@ static struct ptp_clock_info ptp_gianfar_caps = {
 	.owner		= THIS_MODULE,
 	.name		= "gianfar clock",
 	.max_adj	= 512000,
-	.n_alarm	= N_ALARM,
+	.n_alarm	= 0,
 	.n_ext_ts	= N_EXT_TS,
 	.n_per_out	= 0,
 	.pps		= 1,
-- 
1.8.1.2


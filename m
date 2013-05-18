Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3ERC00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24013 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab3ERCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:50 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=W_oy_Qs1ccIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=zkyvjFFMvU4A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=5HgPOz48frnVLXZWc1QA:9 a=MSl-tDqOz04A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021646.064185077@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Richard Cochran <richardcochran@gmail.com>,
        Chris LaRocque <clarocq@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 027/136 ] gianfar: do not advertise any alarm capability.
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0027-gianfar-do-not-advertise-any-alarm-capability.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Richard Cochran <richardcochran@gmail.com>

[ Upstream commit cd4baaaa04b4aaa3b0ec4d13a6f3d203b92eadbd ]

An early draft of the PHC patch series included an alarm in the
gianfar driver. During the review process, the alarm code was dropped,
but the capability removal was overlooked. This patch fixes the issue
by advertising zero alarms.

This patch should be applied to every 3.x stable kernel.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reported-by: Chris LaRocque <clarocq@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/freescale/gianfar_ptp.c |    3 +--
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
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3KIGwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:52:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab3KIGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.11 44/94] target/pscsi: fix return value check
Date: Fri,  8 Nov 2013 22:51:50 -0800
Message-Id: <20131109065207.328160670@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 58932e96e438cd78f75e765d7b87ef39d3533d15 upstream.

In case of error, the function scsi_host_lookup() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_pscsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -134,10 +134,10 @@ static int pscsi_pmode_enable_hba(struct
 	 * pSCSI Host ID and enable for phba mode
 	 */
 	sh = scsi_host_lookup(phv->phv_host_id);
-	if (IS_ERR(sh)) {
+	if (!sh) {
 		pr_err("pSCSI: Unable to locate SCSI Host for"
 			" phv_host_id: %d\n", phv->phv_host_id);
-		return PTR_ERR(sh);
+		return -EINVAL;
 	}
 
 	phv->phv_lld_host = sh;
@@ -515,10 +515,10 @@ static int pscsi_configure_device(struct
 			sh = phv->phv_lld_host;
 		} else {
 			sh = scsi_host_lookup(pdv->pdv_host_id);
-			if (IS_ERR(sh)) {
+			if (!sh) {
 				pr_err("pSCSI: Unable to locate"
 					" pdv_host_id: %d\n", pdv->pdv_host_id);
-				return PTR_ERR(sh);
+				return -EINVAL;
 			}
 		}
 	} else {



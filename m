Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaJ2Vw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:52:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:16996 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910AbaJ2Vw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:52:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,280,1413270000"; 
   d="scan'208";a="613696618"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: hbm: use client specific print functions
Date: Wed, 29 Oct 2014 23:50:58 +0200
Message-Id: <1414619458-7623-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

We have host client in connect/disconnect response processors,
so use client print functions to simplify and unify code.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 65a505226222..c3783d4e3896 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -573,17 +573,17 @@ int mei_hbm_cl_disconnect_rsp(struct mei_device *dev, struct mei_cl *cl)
  * mei_hbm_cl_disconnect_res - update the client state according
  *       disconnect response
  *
+ * @dev: the device structure
  * @cl: mei host client
  * @cmd: disconnect client response host bus message
  */
-static void mei_hbm_cl_disconnect_res(struct mei_cl *cl,
+static void mei_hbm_cl_disconnect_res(struct mei_device *dev, struct mei_cl *cl,
 				      struct mei_hbm_cl_cmd *cmd)
 {
 	struct hbm_client_connect_response *rs =
 		(struct hbm_client_connect_response *)cmd;
 
-	dev_dbg(cl->dev->dev, "hbm: disconnect response cl:host=%02d me=%02d status=%d\n",
-			rs->me_addr, rs->host_addr, rs->status);
+	cl_dbg(dev, cl, "hbm: disconnect response status=%d\n", rs->status);
 
 	if (rs->status == MEI_CL_DISCONN_SUCCESS)
 		cl->state = MEI_FILE_DISCONNECTED;
@@ -609,17 +609,17 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
  * mei_hbm_cl_connect_res - update the client state according
  *        connection response
  *
+ * @dev: the device structure
  * @cl: mei host client
  * @cmd: connect client response host bus message
  */
-static void mei_hbm_cl_connect_res(struct mei_cl *cl,
+static void mei_hbm_cl_connect_res(struct mei_device *dev, struct mei_cl *cl,
 				   struct mei_hbm_cl_cmd *cmd)
 {
 	struct hbm_client_connect_response *rs =
 		(struct hbm_client_connect_response *)cmd;
 
-	dev_dbg(cl->dev->dev, "hbm: connect response cl:host=%02d me=%02d status=%s\n",
-			rs->me_addr, rs->host_addr,
+	cl_dbg(dev, cl, "hbm: connect response status=%s\n",
 			mei_cl_conn_status_str(rs->status));
 
 	if (rs->status == MEI_CL_CONN_SUCCESS)
@@ -668,10 +668,10 @@ static void mei_hbm_cl_res(struct mei_device *dev,
 
 	switch (fop_type) {
 	case MEI_FOP_CONNECT:
-		mei_hbm_cl_connect_res(cl, rs);
+		mei_hbm_cl_connect_res(dev, cl, rs);
 		break;
 	case MEI_FOP_DISCONNECT:
-		mei_hbm_cl_disconnect_res(cl, rs);
+		mei_hbm_cl_disconnect_res(dev, cl, rs);
 		break;
 	default:
 		return;
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaFWBcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39751 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaFWBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:49 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bobi Jam <bobijam.xu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 07/18] staging/lustre/osc: get rid of old checksum initial value
Date: Sun, 22 Jun 2014 21:32:11 -0400
Message-Id: <1403487142-4880-8-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

Old code residue assumes initial checksum value as ~0, and relies on
that to check whether OST server has calculated bulk data checksum.
That is not the case anymore.

Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-on: http://review.whamcloud.com/10354
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4937
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_request.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index 5804104..90e8912 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -1570,12 +1570,7 @@ static int osc_brw_fini_request(struct ptlrpc_request *req, int rc)
 			router = libcfs_nid2str(req->rq_bulk->bd_sender);
 		}
 
-		if (server_cksum == ~0 && rc > 0) {
-			CERROR("Protocol error: server %s set the 'checksum' "
-			       "bit, but didn't send a checksum.  Not fatal, "
-			       "but please notify on http://bugs.whamcloud.com/\n",
-			       libcfs_nid2str(peer->nid));
-		} else if (server_cksum != client_cksum) {
+		if (server_cksum != client_cksum) {
 			LCONSOLE_ERROR_MSG(0x133, "%s: BAD READ CHECKSUM: from "
 					   "%s%s%s inode "DFID" object "DOSTID
 					   " extent ["LPU64"-"LPU64"]\n",
-- 
1.9.0


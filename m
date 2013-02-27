Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab3B0EwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 23:52:23 -0500
Received: from intranet.asianux.com ([58.214.24.6]:20069 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3B0EwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 23:52:21 -0500
X-Spam-Score: -100.7
Message-ID: <512D90F2.9070200@asianux.com>
Date: Wed, 27 Feb 2013 12:52:02 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: konrad.wilk@oracle.com, roger.pau@citrix.com, jbeulich@suse.com,
        stefano.stabellini@eu.citrix.com, dgdegra@tycho.nsa.gov,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/block/xen-blkback: preq.dev is used without initialized
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  if call xen_vbd_translate failed, the preq.dev will be not initialized.
  so use blkif->vbd.pdevice instead (still better to print relative info).

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/block/xen-blkback/blkback.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index de1f319..6d1cc3d 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -904,7 +904,8 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=%04x\n",
 			 operation == READ ? "read" : "write",
 			 preq.sector_number,
-			 preq.sector_number + preq.nr_sects, preq.dev);
+			 preq.sector_number + preq.nr_sects,
+			 blkif->vbd.pdevice);
 		goto fail_response;
 	}
 
-- 
1.7.7.6

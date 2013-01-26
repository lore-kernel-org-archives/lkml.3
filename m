Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3AZTYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 14:24:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48946 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753850Ab3AZTYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 14:24:02 -0500
Message-ID: <1359228240.2079.29.camel@joe-AO722>
Subject: [PATCH] edac: Fix kcalloc argument order
From: Joe Perches <joe@perches.com>
To: Doug Thompson <dougthompson@xmission.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 26 Jan 2013 11:24:00 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First number, then size.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/edac/edac_mc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index a641f62..fb219bc 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -340,7 +340,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	/*
 	 * Alocate and fill the csrow/channels structs
 	 */
-	mci->csrows = kcalloc(sizeof(*mci->csrows), tot_csrows, GFP_KERNEL);
+	mci->csrows = kcalloc(tot_csrows, sizeof(*mci->csrows), GFP_KERNEL);
 	if (!mci->csrows)
 		goto error;
 	for (row = 0; row < tot_csrows; row++) {
@@ -351,7 +351,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 		csr->csrow_idx = row;
 		csr->mci = mci;
 		csr->nr_channels = tot_channels;
-		csr->channels = kcalloc(sizeof(*csr->channels), tot_channels,
+		csr->channels = kcalloc(tot_channels, sizeof(*csr->channels),
 					GFP_KERNEL);
 		if (!csr->channels)
 			goto error;
@@ -369,7 +369,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	/*
 	 * Allocate and fill the dimm structs
 	 */
-	mci->dimms  = kcalloc(sizeof(*mci->dimms), tot_dimms, GFP_KERNEL);
+	mci->dimms  = kcalloc(tot_dimms, sizeof(*mci->dimms), GFP_KERNEL);
 	if (!mci->dimms)
 		goto error;
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3CREan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab3CREaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:03 -0400
Message-Id: <20130318042144.828839007@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 06/82] [SCSI] storvsc: Initialize the sglist
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 9d2696e658ef4f209955ddaa987d43f1a1bd81a1 upstream.

Properly initialize scatterlist before using it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/hv/storvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -815,6 +815,7 @@ static struct scatterlist *create_bounce
 	if (!bounce_sgl)
 		return NULL;
 
+	sg_init_table(bounce_sgl, num_pages);
 	for (i = 0; i < num_pages; i++) {
 		page_buf = alloc_page(GFP_ATOMIC);
 		if (!page_buf)



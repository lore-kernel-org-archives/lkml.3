Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab3CLW7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:59:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3CLWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 05/40] SCSI: storvsc: Initialize the sglist
Date: Tue, 12 Mar 2013 15:43:26 -0700
Message-Id: <20130312223212.055492883@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 9d2696e658ef4f209955ddaa987d43f1a1bd81a1 upstream.

Properly initialize scatterlist before using it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -467,6 +467,7 @@ static struct scatterlist *create_bounce
 	if (!bounce_sgl)
 		return NULL;
 
+	sg_init_table(bounce_sgl, num_pages);
 	for (i = 0; i < num_pages; i++) {
 		page_buf = alloc_page(GFP_ATOMIC);
 		if (!page_buf)



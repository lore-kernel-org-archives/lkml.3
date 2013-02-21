Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3BUTgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:36:35 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47261
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3BUTgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:36:20 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH RESEND 1/4] Drivers: scsi: storvsc: Initialize the sglist
Date: Thu, 21 Feb 2013 12:04:50 -0800
Message-Id: <1361477093-17549-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361477060-17505-1-git-send-email-kys@microsoft.com>
References: <1361477060-17505-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize sglist before using it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 270b3cf..5ada1d0 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -467,6 +467,7 @@ static struct scatterlist *create_bounce_buffer(struct scatterlist *sgl,
 	if (!bounce_sgl)
 		return NULL;
 
+	sg_init_table(bounce_sgl, num_pages);
 	for (i = 0; i < num_pages; i++) {
 		page_buf = alloc_page(GFP_ATOMIC);
 		if (!page_buf)
-- 
1.7.4.1


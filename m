Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbbANHdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:33:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbbANHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:33:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.14 11/77] swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
Date: Tue, 13 Jan 2015 23:22:51 -0800
Message-Id: <20150114072224.803994726@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit 9490c6c67e2f41760de8ece4e4f56f75f84ceb9e upstream.

In xen_swiotlb_sync_single we always call xen_dma_sync_single_for_cpu,
even when we should call xen_dma_sync_single_for_device. Fix that.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -500,7 +500,7 @@ xen_swiotlb_sync_single(struct device *h
 		swiotlb_tbl_sync_single(hwdev, paddr, size, dir, target);
 
 	if (target == SYNC_FOR_DEVICE)
-		xen_dma_sync_single_for_cpu(hwdev, dev_addr, size, dir);
+		xen_dma_sync_single_for_device(hwdev, dev_addr, size, dir);
 
 	if (dir != DMA_FROM_DEVICE)
 		return;



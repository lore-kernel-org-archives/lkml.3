Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbbA1B6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:58:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245AbbA1BiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3.14 35/77] Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"
Date: Tue, 27 Jan 2015 17:27:13 -0800
Message-Id: <20150128012747.019954942@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit dbdd74763f1faf799fbb9ed30423182e92919378 upstream.

This reverts commit 2c3fc8d26dd09b9d7069687eead849ee81c78e46.

This commit broke on x86 PV because entries in the generic SWIOTLB are
indexed using (pseudo-)physical address not DMA address and these are
not the same in a x86 PV guest.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -449,7 +449,7 @@ static void xen_unmap_single(struct devi
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
-		swiotlb_tbl_unmap_single(hwdev, dev_addr, size, dir);
+		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
 		return;
 	}
 



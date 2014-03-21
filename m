Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966579AbaCUAnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:43:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965826AbaCUAIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 22/85] mwifiex: clean pcie ring only when device is present
Date: Thu, 20 Mar 2014 17:09:25 -0700
Message-Id: <20140321000601.790081640@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 4f7ba432202c8330cc03ab959c6228d0de5dc4a3 upstream.

Write io memory to clean PCIe buffer only when PCIe device is
present else this results into crash because of invalid memory
access.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/wmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -556,7 +556,8 @@ mwifiex_clean_txrx(struct mwifiex_privat
 	mwifiex_wmm_delete_all_ralist(priv);
 	memcpy(tos_to_tid, ac_to_tid, sizeof(tos_to_tid));
 
-	if (priv->adapter->if_ops.clean_pcie_ring)
+	if (priv->adapter->if_ops.clean_pcie_ring &&
+	    !priv->adapter->surprise_removed)
 		priv->adapter->if_ops.clean_pcie_ring(priv->adapter);
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }



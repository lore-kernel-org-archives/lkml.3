Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348AbaFIXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:06:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933756AbaFIWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sean MacLennan <seanm@seanm.ca>
Subject: [PATCH 3.14 50/78] staging: r8192e_pci: fix htons error
Date: Mon,  9 Jun 2014 15:48:30 -0700
Message-Id: <20140609224814.963909183@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean MacLennan <seanm@seanm.ca>

commit 9326c5ca0982f548cc08c0cffb14dcbd020f3d43 upstream.

A sparse error fixup removed a htons() which is required for the driver
to function. This patch puts the htons() back and fixes the sparse
warning correctly by changing the left side cast.

Signed-off-by: Sean MacLennan <seanm@seanm.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8192e/rtllib_tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -171,7 +171,7 @@ inline int rtllib_put_snap(u8 *data, u16
 	snap->oui[1] = oui[1];
 	snap->oui[2] = oui[2];
 
-	*(u16 *)(data + SNAP_SIZE) = h_proto;
+	*(__be16 *)(data + SNAP_SIZE) = htons(h_proto);
 
 	return SNAP_SIZE + sizeof(u16);
 }



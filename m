Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab3APAWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:22:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254Ab3AOWaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>,
        Roland Dreier <roland@purestorage.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 089/221] RDMA/nes: Fix for crash when registering zero length MR for CQ
Date: Tue, 15 Jan 2013 10:50:16 -0800
Message-Id: <20130115185004.461014089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>

commit 7d9c199a55200c9b9fcad08e150470d02fb385be upstream.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2559,6 +2559,11 @@ static struct ib_mr *nes_reg_user_mr(str
 			return ibmr;
 		case IWNES_MEMREG_TYPE_QP:
 		case IWNES_MEMREG_TYPE_CQ:
+			if (!region->length) {
+				nes_debug(NES_DBG_MR, "Unable to register zero length region for CQ\n");
+				ib_umem_release(region);
+				return ERR_PTR(-EINVAL);
+			}
 			nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
 			if (!nespbl) {
 				nes_debug(NES_DBG_MR, "Unable to allocate PBL\n");



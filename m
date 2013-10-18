Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117Ab3JSGDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:03:33 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:10092 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab3JSGDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:03:20 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 26/29] vmxnet3: Fixup a weird loop exit
Date: Fri, 18 Oct 2013 19:12:26 +0200
Message-Id: <f0a5f1e64d1b25589aeaf185ce143da123605559.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 5b8ea71..3518173 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2750,7 +2750,7 @@ vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 		} else if (err < 0) {
 			dev_err(&adapter->netdev->dev,
 				   "Failed to enable MSI-X, error: %d\n", err);
-			vectors = 0;
+			return err;
 		} else if (err < vector_threshold) {
 			break;
 		} else {
-- 
1.7.7.6


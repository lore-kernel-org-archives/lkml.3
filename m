Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab3JSGGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:06:54 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:10621 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750964Ab3JSGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:06:53 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 25/29] vmxnet3: Return -EINVAL if number of requested MSI-Xs is not enough
Date: Fri, 18 Oct 2013 19:12:25 +0200
Message-Id: <b67a9cec8bf91993bc057d826c15e357ddfa14f4.1382103786.git.agordeev@redhat.com>
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
index 7e2788c..5b8ea71 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2738,7 +2738,7 @@ static int
 vmxnet3_acquire_msix_vectors(struct vmxnet3_adapter *adapter,
 			     int vectors)
 {
-	int err = 0, vector_threshold;
+	int err = -EINVAL, vector_threshold;
 	vector_threshold = VMXNET3_LINUX_MIN_MSIX_VECT;
 
 	while (vectors >= vector_threshold) {
-- 
1.7.7.6


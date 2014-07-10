Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaGJVyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:54:44 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:39982 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaGJVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:08 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 20/83] hsa/radeon: Add interrupt callback function to kgd2kfd interface
Date: Fri, 11 Jul 2014 00:50:20 +0300
Message-Id: <1405029027-6085-19-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new callback function to the kgd2kfd interface. The
new callback is for propagating interrupts from radeon driver to the kfd
driver.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_module.c | 1 +
 include/linux/radeon_kfd.h          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
index 6978bc0..ad21c6d 100644
--- a/drivers/gpu/hsa/radeon/kfd_module.c
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -38,6 +38,7 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.probe		= kgd2kfd_probe,
 	.device_init	= kgd2kfd_device_init,
 	.device_exit	= kgd2kfd_device_exit,
+	.interrupt	= kgd2kfd_interrupt,
 };
 
 bool kgd2kfd_init(unsigned interface_version,
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index 40b691c..2f4f7c0 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -62,6 +62,7 @@ struct kgd2kfd_calls {
 	struct kfd_dev* (*probe)(struct kgd_dev *kgd, struct pci_dev *pdev);
 	bool (*device_init)(struct kfd_dev *kfd, const struct kgd2kfd_shared_resources *gpu_resources);
 	void (*device_exit)(struct kfd_dev *kfd);
+	void (*interrupt)(struct kfd_dev *kfd, const void *ih_ring_entry);
 };
 
 struct kfd2kgd_calls {
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaGJV5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:57:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:46148 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaGJV5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:25 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 74/83] hsa/radeon: Adding some error messages
Date: Fri, 11 Jul 2014 00:54:30 +0300
Message-Id: <1405029279-6894-46-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 09c9a61..be89d26 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -137,11 +137,15 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	if (copy_from_user(&args, arg, sizeof(args)))
 		return -EFAULT;
 
-	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(qptr_t)))
+	if (!access_ok(VERIFY_WRITE, args.read_pointer_address, sizeof(qptr_t))) {
+		pr_err("kfd: can't access read pointer");
 		return -EFAULT;
+	}
 
-	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(qptr_t)))
+	if (!access_ok(VERIFY_WRITE, args.write_pointer_address, sizeof(qptr_t))) {
+		pr_err("kfd: can't access write pointer");
 		return -EFAULT;
+	}
 
 	q_properties.is_interop = false;
 	q_properties.queue_percent = args.queue_percentage;
-- 
1.9.1


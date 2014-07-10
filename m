Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaGJWJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:09:06 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:35739 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaGJVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:06 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 35/83] hsa/radeon: Print ioctl commnad only in debug mode
Date: Fri, 11 Jul 2014 00:53:51 +0300
Message-Id: <1405029279-6894-7-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index d6fa980..dba6084 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -324,9 +324,9 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	struct kfd_process *process;
 	long err = -EINVAL;
 
-	dev_info(kfd_device,
-		 "ioctl cmd 0x%x (#%d), arg 0x%lx\n",
-		 cmd, _IOC_NR(cmd), arg);
+	dev_dbg(kfd_device,
+		"ioctl cmd 0x%x (#%d), arg 0x%lx\n",
+		cmd, _IOC_NR(cmd), arg);
 
 	process = radeon_kfd_get_process(current);
 	if (IS_ERR(process))
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3AREed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:34:33 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42102
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3AREec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:34:32 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: Bind all vmbbus interrupts to the boot CPU
Date: Thu, 17 Jan 2013 21:00:51 -0800
Message-Id: <1358485251-13801-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default interrupt delivery model in Linux does not support the Hyper-V
vmbus delivery model when the guest is configured with multiple VCPUs. I have
sent a patch to address this - delivering the vmbus interrupt on a separate
IDT vector. Until this patch is applied, bind all vmbus interrupts to the boot
CPU.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index c80fe62..7478ef9 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -337,7 +337,7 @@ static u32 get_vp_index(uuid_le *type_guid)
 		return 0;
 	}
 	cur_cpu = (++next_vp % max_cpus);
-	return hv_context.vp_index[cur_cpu];
+	return 0;
 }
 
 /*
-- 
1.7.4.1


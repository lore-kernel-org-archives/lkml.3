Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab3C2U7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 16:59:49 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:55399
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab3C2U7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 16:59:48 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Stable <stable@vger.kernel.org> (V3.8+)
Subject: [PATCH 1/1] Drivers: hv: vmbus: Fix a bug in hv_need_to_signal()
Date: Fri, 29 Mar 2013 14:30:38 -0700
Message-Id: <1364592638-13090-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of updating the vmbus protocol, the function hv_need_to_signal()
was introduced. This functions helps optimize signalling from guest to
host. The newly added memory barrier is needed to ensure that we correctly
decide when to signal the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Olaf Hering <olh@suse.de>

Cc: Stable <stable@vger.kernel.org>  (V3.8+)
---
 drivers/hv/ring_buffer.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index cafa72f..d6fbb577 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -71,6 +71,7 @@ u32 hv_end_read(struct hv_ring_buffer_info *rbi)
 
 static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 {
+	smp_mb();
 	if (rbi->ring_buffer->interrupt_mask)
 		return false;
 
-- 
1.7.4.1


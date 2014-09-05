Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaIERTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:19:19 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38998
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaIERTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:19:18 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Enable interrupt driven flow control
Date: Fri,  5 Sep 2014 11:23:22 -0700
Message-Id: <1409941402-486-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a win8 feature that has been implemented. Turn on the feature bit
to enable the feature. With this feature turned on, when the host is waiting
for space to become available on the ringbuffer (host to guest), the guest
will interrupt the host when space becomes available (as part of draining
the ring buffer).

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/ring_buffer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 15db66b..6361d12 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	ring_info->ring_buffer->read_index =
 		ring_info->ring_buffer->write_index = 0;
 
+	/*
+	 * Set the feature bit for enabling flow control.
+	 */
+	ring_info->ring_buffer->feature_bits.value = 1;
+
 	ring_info->ring_size = buflen;
 	ring_info->ring_datasize = buflen - sizeof(struct hv_ring_buffer);
 
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3CNUJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:09:32 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33476
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3CNUJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:09:29 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/6] Drivers: hv: balloon: Do not request completion notification
Date: Thu, 14 Mar 2013 13:39:20 -0700
Message-Id: <1363293565-13428-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363293537-13389-1-git-send-email-kys@microsoft.com>
References: <1363293537-13389-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to request completion notification; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 3787321..7fb72dd 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -962,8 +962,7 @@ static int balloon_probe(struct hv_device *dev,
 	ret = vmbus_sendpacket(dev->channel, &version_req,
 				sizeof(struct dm_version_request),
 				(unsigned long)NULL,
-				VM_PKT_DATA_INBAND,
-				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+				VM_PKT_DATA_INBAND, 0);
 	if (ret)
 		goto probe_error2;
 
@@ -1009,8 +1008,7 @@ static int balloon_probe(struct hv_device *dev,
 	ret = vmbus_sendpacket(dev->channel, &cap_msg,
 				sizeof(struct dm_capabilities),
 				(unsigned long)NULL,
-				VM_PKT_DATA_INBAND,
-				VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
+				VM_PKT_DATA_INBAND, 0);
 	if (ret)
 		goto probe_error2;
 
-- 
1.7.4.1


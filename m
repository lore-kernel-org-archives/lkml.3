Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3COSzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:55:45 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:58402
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab3COSzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:55:43 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/6] Drivers: hv: balloon: Do not request completion notification
Date: Fri, 15 Mar 2013 12:25:39 -0700
Message-Id: <1363375544-19901-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363375509-19860-1-git-send-email-kys@microsoft.com>
References: <1363375509-19860-1-git-send-email-kys@microsoft.com>
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


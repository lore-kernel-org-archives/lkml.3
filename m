Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113AbaDIVG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 17:06:58 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54831
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbaDIVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 17:06:14 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net, V1 2/3] Drivers: net: hyperv: Negotiate suitable ndis version for offload support
Date: Wed,  9 Apr 2014 15:00:46 -0700
Message-Id: <1397080847-17994-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1397080847-17994-1-git-send-email-kys@microsoft.com>
References: <1397080810-17953-1-git-send-email-kys@microsoft.com>
 <1397080847-17994-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ws2008R2 supports ndis_version 6.1 and 6.1 is the minimal version required
for various offloads. Negotiate ndis_version 6.1 when on ws2008r2.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index daddea2..f7629ec 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -344,7 +344,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 
 	if (net_device->nvsp_version <= NVSP_PROTOCOL_VERSION_4)
-		ndis_version = 0x00050001;
+		ndis_version = 0x00060001;
 	else
 		ndis_version = 0x0006001e;
 
-- 
1.7.4.1


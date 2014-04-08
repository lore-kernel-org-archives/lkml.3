Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbaDHSvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:51:55 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42305
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbaDHSvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:51:52 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 2/3] Drivers: net: hyperv: Negotiate suitable ndis version for offload support
Date: Tue,  8 Apr 2014 12:46:10 -0700
Message-Id: <1396986371-12137-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1396986371-12137-1-git-send-email-kys@microsoft.com>
References: <1396986332-12098-1-git-send-email-kys@microsoft.com>
 <1396986371-12137-1-git-send-email-kys@microsoft.com>
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


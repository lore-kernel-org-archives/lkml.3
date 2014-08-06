Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbaHFRIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:08:52 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:59034
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827AbaHFRIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:08:51 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of sendbuf region to support ws2008r2
Date: Wed,  6 Aug 2014 11:11:00 -0700
Message-Id: <1407348660-6844-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WS2008R2 is a supported platform and it turns out that the maximum sendbuf
size that ws2008R2 can support is only 15MB. Make the necessary
adjustment.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 40ba1ef..459b823 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -584,7 +584,7 @@ struct nvsp_message {
 
 #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*16)	/* 16MB */
 #define NETVSC_RECEIVE_BUFFER_SIZE_LEGACY	(1024*1024*15)  /* 15MB */
-#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 * 16)   /* 16MB */
+#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 * 15)   /* 15MB */
 #define NETVSC_INVALID_INDEX			-1
 
 
-- 
1.7.4.1


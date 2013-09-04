Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637Ab3IDWG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 18:06:26 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:49080
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab3IDWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 18:06:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Terminate vmbus version negotiation on timeout
Date: Wed,  4 Sep 2013 15:41:58 -0700
Message-Id: <1378334518-23424-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 666b9adc801ef012612c4e43e0f44b2cdc1979cf terminated vmbus
version negotiation incorrectly. We need to terminate the version
negotiation only if the current negotiation were to timeout.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/connection.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8f4743a..936093e 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -195,7 +195,7 @@ int vmbus_connect(void)
 
 	do {
 		ret = vmbus_negotiate_version(msginfo, version);
-		if (ret)
+		if (ret == -ETIMEDOUT)
 			goto cleanup;
 
 		if (vmbus_connection.conn_state == CONNECTED)
-- 
1.7.4.1


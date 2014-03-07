Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaCGHSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 02:18:12 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47268
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaCGHSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 02:18:12 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Increase the limit on the number of pfns we can handle
Date: Fri,  7 Mar 2014 00:10:34 -0800
Message-Id: <1394179834-1629-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the number of PFNs we can handle in a single vmbus packet.
Some network packets may have more PFNs than the current limit we have.
This is not a bug and this patch can be applied to the *next tree. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 include/linux/hyperv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 330ec44..ab7359f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -37,7 +37,7 @@
 #include <linux/mod_devicetable.h>
 
 
-#define MAX_PAGE_BUFFER_COUNT				19
+#define MAX_PAGE_BUFFER_COUNT				32
 #define MAX_MULTIPAGE_BUFFER_COUNT			32 /* 128K */
 
 #pragma pack(push, 1)
-- 
1.7.4.1


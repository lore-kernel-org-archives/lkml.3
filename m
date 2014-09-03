Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaICBRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:17:55 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46218
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbaICBRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:17:54 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] Drivers: hv: util: Properly pack the data for file copy functionality
Date: Tue,  2 Sep 2014 19:21:47 -0700
Message-Id: <1409710907-20818-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly pack the data for file copy functionality. Patch based on
investigation done by Matej Muzila <mmuzila@redhat.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: qge@redhat.com
Cc: <stable@vger.kernel.org>
---
 include/uapi/linux/hyperv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/uapi/linux/hyperv.h b/include/uapi/linux/hyperv.h
index 78e4a86..0a8e6ba 100644
--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -137,7 +137,7 @@ struct hv_do_fcopy {
 	__u64	offset;
 	__u32	size;
 	__u8	data[DATA_FRAGMENT];
-};
+} __attribute__((packed));
 
 /*
  * An implementation of HyperV key value pair (KVP) functionality for Linux.
-- 
1.7.4.1


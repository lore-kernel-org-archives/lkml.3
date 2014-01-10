Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaAJGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 01:41:28 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:44970 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbaAJGlY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 01:41:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2dh87h2a8h839h93fhd24he5bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] genalloc: spinlock_t needs spinlock_types.h
Date: Fri, 10 Jan 2014 14:42:20 +0800
Message-ID: <1389336140-25640-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling a C file which includes genalloc.h but without
spinlock_types.h being included before, we will see the compile error
below.

 include/linux/genalloc.h:54:2: error: unknown type name ‘spinlock_t’

Include spinlock_types.h from genalloc.h to fix the problem.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 include/linux/genalloc.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 1eda33d..1c2fdaa 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -30,6 +30,8 @@
 #ifndef __GENALLOC_H__
 #define __GENALLOC_H__
 
+#include <linux/spinlock_types.h>
+
 struct device;
 struct device_node;
 
-- 
1.7.9.5



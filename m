Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaEUSKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:10:15 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:64210 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbaEUSKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:10:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugLAJzqfFNbsHTp/2dsb2JhbABZgwmCRahABAEBAQEBAQUBgzqWdoEMF3SCZhwjGIECJBOIRQHWTBeFVYh5hEcBA489ijABixWID4M6Ow
Date: Wed, 21 May 2014 20:10:10 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/1] lib/crc32.c: remove unnecessary __constant
Message-Id: <20140521201010.a85463efcbfbaf46b61acae5@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu_to_le32 instead of __constant_cpu_to_le32

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/crc32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 70f00ca..21a7b2135 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -33,13 +33,13 @@
 #include "crc32defs.h"
 
 #if CRC_LE_BITS > 8
-# define tole(x) ((__force u32) __constant_cpu_to_le32(x))
+# define tole(x) ((__force u32) cpu_to_le32(x))
 #else
 # define tole(x) (x)
 #endif
 
 #if CRC_BE_BITS > 8
-# define tobe(x) ((__force u32) __constant_cpu_to_be32(x))
+# define tobe(x) ((__force u32) cpu_to_be32(x))
 #else
 # define tobe(x) (x)
 #endif
-- 
1.9.1

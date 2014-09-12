Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaILKUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:20:52 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:10780 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003AbaILKUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:20:51 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Date: Fri, 12 Sep 2014 18:17:18 +0800
Subject: [PATCH] arm64:free_initrd_mem should also free the memblock
Thread-Topic: [PATCH] arm64:free_initrd_mem should also free the memblock
Thread-Index: Ac/Ocrt9M2HM5eNhS8yrBONkcjGjyQ==
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB029@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fix the memblock statics for memblock
in file /sys/kernel/debug/memblock/reserved
if we don't call memblock_free the initrd will still
be marked as reserved, even they are freed.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm64/mm/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..34605c8 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -334,8 +334,10 @@ static int keep_initrd;
 
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd)
+	if (!keep_initrd) {
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
+		memblock_free(__pa(start), end - start);
+	}
 }
 
 static int __init keepinitrd_setup(char *__unused)
-- 
2.1.0

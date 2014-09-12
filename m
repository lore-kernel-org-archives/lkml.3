Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaILKMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:12:15 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16972 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbaILKMK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:12:10 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Date: Fri, 12 Sep 2014 18:05:04 +0800
Subject: [PATCH] arm:free_initrd_mem should also free the memblock
Thread-Topic: [PATCH] arm:free_initrd_mem should also free the memblock
Thread-Index: Ac/OcQYK+iHegZKaRzKAERxvRcdQnQ==
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB028@CNBJMBX05.corpusers.net>
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
 arch/arm/mm/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..7bc8e5b 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -638,6 +638,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
 		free_reserved_area((void *)start, (void *)end, -1, "initrd");
+		memblock_free(__pa(start), end - start);
 	}
 }
 
-- 
2.1.0

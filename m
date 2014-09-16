Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaIPFM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 01:12:26 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:19494 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbaIPFMZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 01:12:25 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Jiang Liu'" <jiang.liu@huawei.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 16 Sep 2014 13:09:30 +0800
Subject: [RFC] change keep_initrd and free_initrd_mem into .init section
Thread-Topic: [RFC] change keep_initrd and free_initrd_mem into .init section
Thread-Index: Ac/RbGU0znnwtjO0SdCctZwc0yijzQ==
Message-ID: <35FD53F367049845BC99AC72306C23D103D6DB49160E@CNBJMBX05.corpusers.net>
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

this patch change keep_initrd to __initdata section,
and free_initrd_mem to __init section so that they can be freed by
free_initmem, free_initrd_mem is only called by free_initrd function,
so it's safe to free it after use.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm/mm/init.c   | 4 ++--
 arch/arm64/mm/init.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..907dee1 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -631,9 +631,9 @@ void free_initmem(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static int keep_initrd;
+static int __initdata keep_initrd;
 
-void free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd) {
 		poison_init_mem((void *)start, PAGE_ALIGN(end) - start);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..7268d57 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -330,9 +330,9 @@ void free_initmem(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static int keep_initrd;
+static int __initdata keep_initrd;
 
-void free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	if (!keep_initrd)
 		free_reserved_area((void *)start, (void *)end, 0, "initrd");
-- 
2.1.0

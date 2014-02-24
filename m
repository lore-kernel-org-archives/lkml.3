Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaBXFmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:42:52 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45857 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaBXFmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:42:50 -0500
Date: Mon, 24 Feb 2014 13:42:41 +0800
From: majianpeng <majianpeng@gmail.com>
To: joro <joro@8bytes.org>, tglx <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [TRIVIAL][PATCH] x86/ioapic: Using printk  in func print_entries avoiding print incomplete infos
X-Priority: 3
X-GUID: CE11DB2D-205A-43A6-B02D-3396E4D548B7
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201402241342361562172@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1O5gvPX011645

Commit(afcc8a40a090f): Introduce x86_io_apic_ops.print_entries for
debugging. Using kernel parameter apci=debug/verbose, kernel print
the incomplete infomation if we don't enable CONFIG_DYNAMIC_DEBUG.
So using printk to replace.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..26996fc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1480,14 +1480,14 @@ void native_io_apic_print_entries(unsigned int apic, unsigned int nr_entries)
 {
 	int i;
 
-	pr_debug(" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
+	printk(KERN_DEBUG" NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:\n");
 
 	for (i = 0; i <= nr_entries; i++) {
 		struct IO_APIC_route_entry entry;
 
 		entry = ioapic_read_entry(apic, i);
 
-		pr_debug(" %02x %02X  ", i, entry.dest);
+		printk(KERN_DEBUG" %02x %02X  ", i, entry.dest);
 		pr_cont("%1d    %1d    %1d   %1d   %1d    "
 			"%1d    %1d    %02X\n",
 			entry.mask,
@@ -1506,7 +1506,7 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
 {
 	int i;
 
-	pr_debug(" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
+	printk(KERN_DEBUG" NR Indx Fmt Mask Trig IRR Pol Stat Indx2 Zero Vect:\n");
 
 	for (i = 0; i <= nr_entries; i++) {
 		struct IR_IO_APIC_route_entry *ir_entry;
@@ -1516,7 +1516,7 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
 
 		ir_entry = (struct IR_IO_APIC_route_entry *)&entry;
 
-		pr_debug(" %02x %04X ", i, ir_entry->index);
+		printk(KERN_DEBUG " %02x %04X ", i, ir_entry->index);
 		pr_cont("%1d   %1d    %1d    %1d   %1d   "
 			"%1d    %1d     %X    %02X\n",
 			ir_entry->format,
-- 
1.7.10.4
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

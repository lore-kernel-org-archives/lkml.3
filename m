Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaEAT4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:56:42 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:6380 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaEAT4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:56:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8cAKOmYlNXQzTn/2dsb2JhbABagwaDPKgtAwUEAZoGAgKBExd0gmYcIxiBAiQTiEUBygqFVoh8hEABA48WihgBinqHdIM1Ow
Date: Thu, 1 May 2014 21:58:23 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] arch/m68k/apollo/config.c: convert printk to pr_foo()
Message-Id: <20140501215823.641182bdc31116f0f47ec7b6@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no level printk converted to pr_info

This is untested

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/m68k/apollo/config.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 9268c0f..42d393f 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -65,8 +65,8 @@ int __init apollo_parse_bootinfo(const struct bi_record *record)
 
 static void __init dn_setup_model(void)
 {
-	printk("Apollo hardware found: ");
-	printk("[%s]\n", apollo_models[apollo_model - APOLLO_DN3000]);
+	pr_info("Apollo hardware found: ");
+	pr_cont("[%s]\n", apollo_models[apollo_model - APOLLO_DN3000]);
 
 	switch(apollo_model) {
 		case APOLLO_UNKNOWN:
@@ -197,8 +197,10 @@ void dn_sched_init(irq_handler_t timer_routine)
 	*(volatile unsigned char *)(pica+1)&=(~8);
 
 #if 0
-	printk("*(0x10803) %02x\n",*(volatile unsigned char *)(apollo_timer + 0x3));
-	printk("*(0x10803) %02x\n",*(volatile unsigned char *)(apollo_timer + 0x3));
+	pr_info("*(0x10803) %02x\n",
+		*(volatile unsigned char *)(apollo_timer + 0x3));
+	pr_info("*(0x10803) %02x\n",
+		*(volatile unsigned char *)(apollo_timer + 0x3));
 #endif
 
 	if (request_irq(IRQ_APOLLO, dn_timer_int, 0, "time", timer_routine))
@@ -236,12 +238,10 @@ int dn_dummy_hwclk(int op, struct rtc_time *t) {
 
 }
 
-int dn_dummy_set_clock_mmss(unsigned long nowtime) {
-
-  printk("set_clock_mmss\n");
-
-  return 0;
-
+int dn_dummy_set_clock_mmss(unsigned long nowtime)
+{
+	pr_info("set_clock_mmss\n");
+	return 0;
 }
 
 void dn_dummy_reset(void) {
-- 
1.8.4.5

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaEATy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:54:28 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:13601 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbaEATy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:54:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8cALmlYlNXQzTn/2dsb2JhbABagwaDPKgtAwUEAZoGAgKBExd0glMTHCMYgQIkE4hFAcoQhVaIfIRAAQOPFooYAYp6h3SDNTs
Date: Thu, 1 May 2014 21:56:29 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH V2] ARCH/M68K/AMIGA: convert printk to pr_foo()
Message-Id: <20140501215629.7d85c5c79be5548272fee8e1@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-no level printk converted to pr_warn/pr_info
-fixed a small indentation problem

This is untested

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v2: use pr_cont after pr_ without newline (suggested by Geert Uytterhoeven)

 arch/m68k/amiga/amisound.c |  2 +-
 arch/m68k/amiga/config.c   | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
index 2559eef..90a60d7 100644
--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -51,7 +51,7 @@ void __init amiga_init_sound(void)
 
 	snd_data = amiga_chip_alloc_res(sizeof(sine_data), &beep_res);
 	if (!snd_data) {
-		printk (KERN_CRIT "amiga init_sound: failed to allocate chipmem\n");
+		pr_crit("amiga init_sound: failed to allocate chipmem\n");
 		return;
 	}
 	memcpy (snd_data, sine_data, sizeof(sine_data));
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 9625b71..01693df 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -183,7 +183,7 @@ int __init amiga_parse_bootinfo(const struct bi_record *record)
 			dev->boardaddr = be32_to_cpu(cd->cd_BoardAddr);
 			dev->boardsize = be32_to_cpu(cd->cd_BoardSize);
 		} else
-			printk("amiga_parse_bootinfo: too many AutoConfig devices\n");
+			pr_warn("amiga_parse_bootinfo: too many AutoConfig devices\n");
 #endif /* CONFIG_ZORRO */
 		break;
 
@@ -209,9 +209,9 @@ static void __init amiga_identify(void)
 
 	memset(&amiga_hw_present, 0, sizeof(amiga_hw_present));
 
-	printk("Amiga hardware found: ");
+	pr_info("Amiga hardware found: ");
 	if (amiga_model >= AMI_500 && amiga_model <= AMI_DRACO) {
-		printk("[%s] ", amiga_models[amiga_model-AMI_500]);
+		pr_cont("[%s] ", amiga_models[amiga_model-AMI_500]);
 		strcat(amiga_model_name, amiga_models[amiga_model-AMI_500]);
 	}
 
@@ -322,7 +322,7 @@ static void __init amiga_identify(void)
 
 #define AMIGAHW_ANNOUNCE(name, str)		\
 	if (AMIGAHW_PRESENT(name))		\
-		printk(str)
+		pr_cont(str)
 
 	AMIGAHW_ANNOUNCE(AMI_VIDEO, "VIDEO ");
 	AMIGAHW_ANNOUNCE(AMI_BLITTER, "BLITTER ");
@@ -354,8 +354,8 @@ static void __init amiga_identify(void)
 	AMIGAHW_ANNOUNCE(MAGIC_REKICK, "MAGIC_REKICK ");
 	AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA ");
 	if (AMIGAHW_PRESENT(ZORRO))
-		printk("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");
-	printk("\n");
+		pr_cont("ZORRO%s ", AMIGAHW_PRESENT(ZORRO3) ? "3" : "");
+	pr_cont("\n");
 
 #undef AMIGAHW_ANNOUNCE
 }
@@ -424,7 +424,7 @@ void __init config_amiga(void)
 			if (m68k_memory[i].addr < 16*1024*1024) {
 				if (i == 0) {
 					/* don't cut off the branch we're sitting on */
-					printk("Warning: kernel runs in Zorro II memory\n");
+					pr_warn("Warning: kernel runs in Zorro II memory\n");
 					continue;
 				}
 				disabled_z2mem += m68k_memory[i].size;
@@ -435,8 +435,8 @@ void __init config_amiga(void)
 			}
 		}
 		if (disabled_z2mem)
-		printk("%dK of Zorro II memory will not be used as system memory\n",
-		disabled_z2mem>>10);
+			pr_info("%dK of Zorro II memory will not be used as system memory\n",
+				disabled_z2mem>>10);
 	}
 
 	/* request all RAM */
@@ -475,7 +475,7 @@ static void __init amiga_sched_init(irq_handler_t timer_routine)
 	jiffy_ticks = DIV_ROUND_CLOSEST(amiga_eclock, HZ);
 
 	if (request_resource(&mb_resources._ciab, &sched_res))
-		printk("Cannot allocate ciab.ta{lo,hi}\n");
+		pr_warn("Cannot allocate ciab.ta{lo,hi}\n");
 	ciab.cra &= 0xC0;   /* turn off timer A, continuous mode, from Eclk */
 	ciab.talo = jiffy_ticks % 256;
 	ciab.tahi = jiffy_ticks / 256;
-- 
1.8.4.5

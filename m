Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaEJKmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 06:42:51 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:24719 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850AbaEJKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 06:42:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQWAAcCblNXQCSg/2dsb2JhbABZgwaDPakXCgUBmhUCAoEXF3SCZhwjGIECJBOIRQHRT4VWiHyERwEDjyWKIgGLBIgDgzg7
Date: Sat, 10 May 2014 12:42:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/1 RESEND] arch/m68k/hp300/config.c: convert printk to
 pr_foo()
Message-Id: <20140510124243.750ad9c92d4549f3a8f11eb5@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also fixes some checkpatch warnings

This is untested

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/m68k/hp300/config.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/hp300/config.c b/arch/m68k/hp300/config.c
index 2e5a787..a9befe6 100644
--- a/arch/m68k/hp300/config.c
+++ b/arch/m68k/hp300/config.c
@@ -87,7 +87,7 @@ int __init hp300_parse_bootinfo(const struct bi_record *record)
 		/* serial port address: ignored here */
 		break;
 
-        default:
+	default:
 		unknown = 1;
 	}
 
@@ -262,11 +262,12 @@ void __init config_hp300(void)
 #endif
 	mach_max_dma_address = 0xffffffff;
 
-	if (hp300_model >= HP_330 && hp300_model <= HP_433S && hp300_model != HP_350) {
-		printk(KERN_INFO "Detected HP9000 model %s\n", hp300_models[hp300_model-HP_320]);
+	if (hp300_model >= HP_330 && hp300_model <= HP_433S &&
+	    hp300_model != HP_350) {
+		pr_info("Detected HP9000 model %s\n",
+			hp300_models[hp300_model-HP_320]);
 		strcat(hp300_model_name, hp300_models[hp300_model-HP_320]);
-	}
-	else {
+	} else {
 		panic("Unknown HP9000 Model");
 	}
 #ifdef CONFIG_SERIAL_8250_CONSOLE
-- 
1.8.4.5


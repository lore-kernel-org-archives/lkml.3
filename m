Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3JRLY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:24:29 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:46144 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab3JRLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:24:26 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 2/2] m68k/amiga: Provide mach_random_get_entropy()
Date: Fri, 18 Oct 2013 13:24:13 +0200
Message-Id: <1382095453-24086-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382095453-24086-1-git-send-email-geert@linux-m68k.org>
References: <1382095453-24086-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the beam position registers, which provide at least 17 bits of data
changing at 1.79 MHz.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Use beam position registers (which provide a faster rate but less bits)
    instead of 24-bit Time-Of-Day clock in CIA B running at HSYNC.

 arch/m68k/amiga/config.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index f78361bff623..0b46d32a345f 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -354,6 +354,14 @@ static void __init amiga_identify(void)
 #undef AMIGAHW_ANNOUNCE
 }
 
+
+static unsigned long amiga_random_get_entropy(void)
+{
+	/* VPOSR/VHPOSR provide at least 17 bits of data changing at 1.79 MHz */
+	return *(unsigned long *)&amiga_custom.vposr;
+}
+
+
     /*
      *  Setup the Amiga configuration info
      */
@@ -391,6 +399,8 @@ void __init config_amiga(void)
 	mach_heartbeat = amiga_heartbeat;
 #endif
 
+	mach_random_get_entropy = amiga_random_get_entropy;
+
 	/* Fill in the clock value (based on the 700 kHz E-Clock) */
 	amiga_colorclock = 5*amiga_eclock;	/* 3.5 MHz */
 
-- 
1.7.9.5


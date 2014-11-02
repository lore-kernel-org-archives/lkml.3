Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaKBSQu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 13:16:50 -0500
Received: from relay2.sgi.com ([192.48.180.65]:42196 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbaKBSQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 13:16:49 -0500
From: James Custer <jcuster@sgi.com>
To: x86@kernel.org
Cc: James Custer <jcuster@sgi.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/2] x86: UV BAU Increase maximum CPUs per socket/hub
Date: Sun,  2 Nov 2014 12:16:38 -0600
Message-Id: <1414952199-185319-1-git-send-email-jcuster@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have encountered hardware with 18 cores/socket that gives 36 CPUs/socket
with hyperthreading enabled. This exceeds the current MAX_CPUS_PER_SOCKET
causing a failure in get_cpu_topology. Increase MAX_CPUS_PER_SOCKET to 64
and MAX_CPUS_PER_UVHUB to 128.

Signed-off-by: James Custer <jcuster@sgi.com>
---
 arch/x86/include/asm/uv/uv_bau.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 2d60a78..fc808b8 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -33,8 +33,8 @@
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
-#define MAX_CPUS_PER_UVHUB		64
-#define MAX_CPUS_PER_SOCKET		32
+#define MAX_CPUS_PER_UVHUB		128
+#define MAX_CPUS_PER_SOCKET		64
 #define ADP_SZ				64 /* hardware-provided max. */
 #define UV_CPUS_PER_AS			32 /* hardware-provided max. */
 #define ITEMS_PER_DESC			8
-- 
1.7.12.4


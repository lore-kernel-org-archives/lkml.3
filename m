Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBIV5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:57:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42011 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaBIV5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:57:14 -0500
Date: Sun, 9 Feb 2014 13:56:44 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: [PATCH] x86, kaslr: add missed "static" declarations
Message-ID: <20140209215644.GA30339@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This silences build warnings about unexported variables and functions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 90a21f430117..4dbf967da50d 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -111,7 +111,7 @@ struct mem_vector {
 };
 
 #define MEM_AVOID_MAX 5
-struct mem_vector mem_avoid[MEM_AVOID_MAX];
+static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
 {
@@ -180,7 +180,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 }
 
 /* Does this memory vector overlap a known avoided area? */
-bool mem_avoid_overlap(struct mem_vector *img)
+static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
 
@@ -192,8 +192,9 @@ bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
-unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET / CONFIG_PHYSICAL_ALIGN];
-unsigned long slot_max = 0;
+static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
+			   CONFIG_PHYSICAL_ALIGN];
+static unsigned long slot_max;
 
 static void slots_append(unsigned long addr)
 {
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security

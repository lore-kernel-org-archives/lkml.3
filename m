Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbbAUDhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825AbbAUDhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:37:41 -0500
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de,
        Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/6] remove a unused function parameter
Date: Wed, 21 Jan 2015 11:37:12 +0800
Message-Id: <1421811437-2787-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a clean up to simplify the later change.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index bb13763..9a7210c 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -135,7 +135,7 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 }
 
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
-			   unsigned long output, unsigned long output_size)
+			   unsigned long output_size)
 {
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
@@ -317,7 +317,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_size);
+		       output_size);
 
 	/* Walk e820 and find a random address. */
 	random = find_random_addr(choice, output_size);
-- 
1.9.3


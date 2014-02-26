Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaBZBHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:07:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34174 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaBZBHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:07:12 -0500
Date: Tue, 25 Feb 2014 17:06:57 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-e290e8c59dbc2a15088d868170d799f763202fef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140209215644.GA30339@www.outflux.net>
References: <20140209215644.GA30339@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, kaslr: add missed "static" declarations
Git-Commit-ID: e290e8c59dbc2a15088d868170d799f763202fef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e290e8c59dbc2a15088d868170d799f763202fef
Gitweb:     http://git.kernel.org/tip/e290e8c59dbc2a15088d868170d799f763202fef
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Sun, 9 Feb 2014 13:56:44 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Feb 2014 16:59:29 -0800

x86, kaslr: add missed "static" declarations

This silences build warnings about unexported variables and functions.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20140209215644.GA30339@www.outflux.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/aslr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 90a21f4..4dbf967 100644
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

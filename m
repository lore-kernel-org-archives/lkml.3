Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3EZK26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:28:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13081 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3EZK2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:28:55 -0400
X-Spam-Score: -100.8
Message-ID: <51A1E3B3.4060901@asianux.com>
Date: Sun, 26 May 2013 18:28:03 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, vgupta@synopsys.com,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: arm64: kernel: sprintf(), 'str' needs additional 1
 byte for failure processing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When failure occurs at the last looping cycle (when 'i == 0'), it will
print "bad PC value" instead of "(%08x) ", which needs additional 1
byte.

If not add 1 byte, the str will not be NUL terminated, and the next
printk() will cause issue.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 61d7dd2..c2f68d2 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -100,7 +100,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
 {
 	unsigned long addr = instruction_pointer(regs);
 	mm_segment_t fs;
-	char str[sizeof("00000000 ") * 5 + 2 + 1], *p = str;
+	char str[sizeof("00000000 ") * 5 + 2 + 1 + 1], *p = str;
 	int i;
 
 	/*
-- 
1.7.7.6

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3EaMtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:49:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57957 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3EaMtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:49:07 -0400
Date: Fri, 31 May 2013 05:48:55 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-1d10f6ee602ec5a4bd0c1606ba5f38277da432e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <51A610B802000078000D99A0@nat28.tlf.novell.com>
References: <51A610B802000078000D99A0@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: __force_order doesn'
 t need to be an actual variable
Git-Commit-ID: 1d10f6ee602ec5a4bd0c1606ba5f38277da432e1
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

Commit-ID:  1d10f6ee602ec5a4bd0c1606ba5f38277da432e1
Gitweb:     http://git.kernel.org/tip/1d10f6ee602ec5a4bd0c1606ba5f38277da432e1
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 29 May 2013 13:29:12 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 31 May 2013 13:09:17 +0200

x86: __force_order doesn't need to be an actual variable

It being static causes over a dozen instances to be scattered
across the kernel image, with non of them ever being referenced
in any way. Making the variable extern without ever defining it
works as well - all we need is to have the compiler think the
variable is being accessed.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/51A610B802000078000D99A0@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/special_insns.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 41fc93a..2f4d924 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -16,7 +16,7 @@ static inline void native_clts(void)
  * all loads stores around it, which can hurt performance. Solution is to
  * use a variable and mimic reads and writes to it to enforce serialization
  */
-static unsigned long __force_order;
+extern unsigned long __force_order;
 
 static inline unsigned long native_read_cr0(void)
 {

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3F0Gou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:44:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1921 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3F0Gos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:44:48 -0400
X-Spam-Score: -100.9
Message-ID: <51CBDF2B.8090304@asianux.com>
Date: Thu, 27 Jun 2013 14:43:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: starvik@axis.com, Jesper Nilsson <jesper.nilsson@axis.com>
CC: Andrew Morton <akpm@linux-foundation.org>, shaohua.li@fusionio.com,
        linux-cris-kernel@axis.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: cris: mm: add a code block for variable declaration
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need a code block for variable declaration, or can not pass compiling
by old C compiler.

The new C compiler will report the warning (with allmodconfig):

  arch/cris/mm/fault.c: In function ‘do_page_fault’:
  arch/cris/mm/fault.c:228:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/cris/mm/fault.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/cris/mm/fault.c b/arch/cris/mm/fault.c
index 73312ab..919ab17c 100644
--- a/arch/cris/mm/fault.c
+++ b/arch/cris/mm/fault.c
@@ -225,8 +225,10 @@ retry:
 			show_registers(regs);
 
 #ifdef CONFIG_NO_SEGFAULT_TERMINATION
-		DECLARE_WAIT_QUEUE_HEAD(wq);
-		wait_event_interruptible(wq, 0 == 1);
+		{
+			DECLARE_WAIT_QUEUE_HEAD(wq);
+			wait_event_interruptible(wq, 0 == 1);
+		}
 #else
 		info.si_signo = SIGSEGV;
 		info.si_errno = 0;
-- 
1.7.7.6

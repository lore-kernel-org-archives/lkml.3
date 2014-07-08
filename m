Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaGHHnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:43:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46405 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaGHHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:43:51 -0400
Message-ID: <53BBA133.9010104@gmail.com>
Date: Tue, 08 Jul 2014 15:43:47 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/Kconfig: Remain but disable STACKTRACE_SUPPORT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If enable STACKTRACE_SUPPORT, score has to implement save_stack_trace()
too. At present, it does not implement save_stack_trace(). So remain
but disable STACKTRACE_SUPPORT, just like um architecture has done.

    LD      init/built-in.o
  kernel/built-in.o: In function `save_trace':
  lockdep.c:(.text.save_trace+0x44): undefined reference to `save_stack_trace'
  kernel/built-in.o: In function `match_held_lock':
  lockdep.c:(.text.match_held_lock+0x78): undefined reference to `save_stack_trace'
  kernel/built-in.o: In function `.L1144':
  lockdep.c:(.text.lockdep_init_map+0x1a4): undefined reference to `save_stack_trace'
  kernel/built-in.o: In function `.L1197':
  lockdep.c:(.text.__lock_acquire+0x14c): undefined reference to `save_stack_trace'
  kernel/built-in.o: In function `.L1856':
  lockdep.c:(.text.__lock_set_class+0x160): undefined reference to `save_stack_trace'
  kernel/built-in.o:(.text.lockdep_reset_lock+0xa0): more undefined references to `save_stack_trace' follow
  make: *** [vmlinux] Error 1


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4ac8cae..2ba8d05 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -76,7 +76,7 @@ config LOCKDEP_SUPPORT
 	def_bool y
 
 config STACKTRACE_SUPPORT
-	def_bool y
+	def_bool n
 
 source "init/Kconfig"
 
-- 
1.9.2.459.g68773ac

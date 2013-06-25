Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3FYC4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:56:11 -0400
Received: from intranet.asianux.com ([58.214.24.6]:32512 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYC4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:56:09 -0400
X-Spam-Score: -100.8
Message-ID: <51C90696.6040407@asianux.com>
Date: Tue, 25 Jun 2013 10:55:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "dhowells@redhat.com" <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
CC: linux-am33-list@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: mn10300: Kconfig: remove 'KPROBES' options
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, mn10300 does not implement 'KPROBES', so need remove it now,
or can not pass compiling with allmodconfig.

The related error (with allmodconfig):
  In file included from arch/mn10300/kernel/kprobes.c:20:0:
  include/linux/kprobes.h: In function ‘get_kprobe_ctlblk’:
  include/linux/kprobes.h:332:11: error: dereferencing pointer to incomplete type

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/mn10300/Kconfig.debug |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
index bdbfd44..624de7d 100644
--- a/arch/mn10300/Kconfig.debug
+++ b/arch/mn10300/Kconfig.debug
@@ -24,16 +24,6 @@ config TEST_MISALIGNMENT_HANDLER
 	  accesses to make sure the misalignment handler deals them with
 	  correctly.  If it does not, the kernel will throw a BUG.
 
-config KPROBES
-	bool "Kprobes"
-	depends on DEBUG_KERNEL
-	help
-	  Kprobes allows you to trap at almost any kernel address and
-	  execute a callback function.  register_kprobe() establishes
-	  a probepoint and specifies the callback.  Kprobes is useful
-	  for kernel debugging, non-intrusive instrumentation and testing.
-	  If in doubt, say "N".
-
 config GDBSTUB
 	bool "Remote GDB kernel debugging"
 	depends on DEBUG_KERNEL && DEPRECATED
-- 
1.7.7.6

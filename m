Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbaIRScE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:32:04 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:56892 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRScB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:32:01 -0400
Message-ID: <1411065119.2017.73.camel@x220>
Subject: [PATCH 1/5] MN10300: Remove Kconfig symbol GDBSTUB
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Sep 2014 20:31:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2014 18:31:59.0991 (UTC) FILETIME=[D5907070:01CFD36E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1a8d59e529d0 ("MN10300: Deprecate gdbstub") made the Kconfig
symbol GDBSTUB depend on DEPRECATED. Since that Kconfig symbol doesn't
exist, this Kconfig entry has been dead since v2.6.39. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/mn10300/Kconfig.debug | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/mn10300/Kconfig.debug b/arch/mn10300/Kconfig.debug
index 94efb3ed223f..6a8c7e8d6156 100644
--- a/arch/mn10300/Kconfig.debug
+++ b/arch/mn10300/Kconfig.debug
@@ -30,21 +30,6 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
-config GDBSTUB
-	bool "Remote GDB kernel debugging"
-	depends on DEBUG_KERNEL && DEPRECATED
-	select DEBUG_INFO
-	select FRAME_POINTER
-	help
-	  If you say Y here, it will be possible to remotely debug the kernel
-	  using gdb. This enlarges your kernel ELF image disk size by several
-	  megabytes and requires a machine with more than 16 MB, better 32 MB
-	  RAM to avoid excessive linking time. This is only useful for kernel
-	  hackers. If unsure, say N.
-
-	  This is deprecated in favour of KGDB and will be removed in a later
-	  version.
-
 config GDBSTUB_IMMEDIATE
 	bool "Break into GDB stub immediately"
 	depends on GDBSTUB
-- 
1.9.3


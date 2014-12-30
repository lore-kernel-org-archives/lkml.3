Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaL3PhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:37:01 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36033 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaL3Pgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:36:55 -0500
Date: Tue, 30 Dec 2014 16:36:50 +0100
From: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: tools: shell-ify calc_run_size perl-ism
Message-ID: <20141230153650.GA5067@dhcppc1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix makefile.

Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@gmail.com>
---
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -77,7 +77,7 @@ suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
 RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
+	     sh $(srctree)/arch/x86/tools/calc_run_size.sh)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 

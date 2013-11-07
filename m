Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab3KGQ26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:28:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58172 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KGQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:28:56 -0500
Message-ID: <527BBFC4.4020307@infradead.org>
Date: Thu, 07 Nov 2013 08:28:52 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, lailavrazda1979@gmail.com
Subject: [PATCH v2] kcore: add Kconfig help text
References: <527B2A76.2000501@infradead.org> <15490.1383839848@warthog.procyon.org.uk>
In-Reply-To: <15490.1383839848@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Under Pseudo filesystems, /proc/kcore support has no help.

Fixes a portion of kernel bugzilla #52671:
  https://bugzilla.kernel.org/show_bug.cgi?id=52671

Thanks for David Howells for the help text.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: lailavrazda1979@gmail.com
---
 fs/proc/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- lnx-312.orig/fs/proc/Kconfig
+++ lnx-312/fs/proc/Kconfig
@@ -31,6 +31,10 @@ config PROC_FS
 config PROC_KCORE
 	bool "/proc/kcore support" if !ARM
 	depends on PROC_FS && MMU
+	help
+	  Provides a virtual ELF core file of the live kernel.  This can
+	  be read with gdb and other ELF tools.  No modifications can be
+	  made using this mechanism.
 
 config PROC_VMCORE
 	bool "/proc/vmcore support"

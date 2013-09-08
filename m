Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab3IHDVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56248 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845Ab3IHDS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jesper Nilsson" <jesper.nilsson@axis.com>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.94924052@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [094/121] CRIS: Add _sdata to vmlinux.lds.S
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jesper Nilsson <jesper.nilsson@axis.com>

commit 473e162eea465e60578edb93341752e7f1c1dacc upstream.

Fixes link error:
  LD      vmlinux
kernel/built-in.o: In function `core_kernel_data':
(.text+0x13e44): undefined reference to `_sdata'

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/cris/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 
 	EXCEPTION_TABLE(4)
 
+	_sdata = .;
 	RODATA
 
 	. = ALIGN (4);


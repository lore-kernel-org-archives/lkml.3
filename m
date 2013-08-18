Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3HRU2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:28:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab3HRU2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:28:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 02/12] CRIS: Add _sdata to vmlinux.lds.S
Date: Sun, 18 Aug 2013 13:30:11 -0700
Message-Id: <20130818202950.283528309@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818202949.875887601@linuxfoundation.org>
References: <20130818202949.875887601@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 arch/cris/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 
 	EXCEPTION_TABLE(4)
 
+	_sdata = .;
 	RODATA
 
 	. = ALIGN (4);



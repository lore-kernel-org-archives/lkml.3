Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423119AbaDKQ0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759649AbaDKQJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.13 64/65] m68k: Skip futex_atomic_cmpxchg_inatomic() test
Date: Fri, 11 Apr 2014 09:11:36 -0700
Message-Id: <20140411161006.433899682@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@telegraphics.com.au>

commit e571c58f313d35c56e0018470e3375ddd1fd320e upstream.

Skip the futex_atomic_cmpxchg_inatomic() test in futex_init(). It causes a
fatal exception on 68030 (and presumably 68020 also).

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1403061006440.5525@nippy.intranet
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -17,6 +17,7 @@ config M68K
 	select FPU if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select HAVE_FUTEX_CMPXCHG if MMU && FUTEX
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA



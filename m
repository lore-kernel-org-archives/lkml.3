Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbaKTVy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:54:26 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:55323 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbaKTVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:54:22 -0500
Date: Thu, 20 Nov 2014 22:54:18 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: linux-mips@linux-mips.org, aaro.koskinen@iki.fi, david.daney@cavium.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, chenhc@lemote.com, akpm@linux-foundation.org
Subject: Re: [PATCH] MIPS: Remove a temporary hack for debugging cache
 flushes in SMTC configuration
Message-ID: <20141120215417.GA20017@linux-mips.org>
References: <20140906022738.6957.53838.stgit@linux-yegoshin>
 <20141120214557.GA19608@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120214557.GA19608@linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:45:58PM +0100, Ralf Baechle wrote:

> So I'm more thinking of something like below.

And while we're at it, these were unused rsp. only used by other
unused macros.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/include/asm/r4kcache.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index cd6e0af..392b159 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -124,10 +124,6 @@ extern void mt_cflush_release(void);
 
 #define __inv_dflush_prologue __dflush_prologue
 #define __inv_dflush_epilogue __dflush_epilogue
-#define __sflush_prologue {
-#define __sflush_epilogue }
-#define __inv_sflush_prologue __sflush_prologue
-#define __inv_sflush_epilogue __sflush_epilogue
 
 #else /* CONFIG_MIPS_MT */
 
@@ -137,10 +133,6 @@ extern void mt_cflush_release(void);
 #define __dflush_epilogue }
 #define __inv_dflush_prologue {
 #define __inv_dflush_epilogue }
-#define __sflush_prologue {
-#define __sflush_epilogue }
-#define __inv_sflush_prologue {
-#define __inv_sflush_epilogue }
 
 #endif /* CONFIG_MIPS_MT */
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3K2C2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 21:28:00 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56589 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3K2C14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 21:27:56 -0500
Message-ID: <5297FC23.3030507@gmail.com>
Date: Fri, 29 Nov 2013 10:29:55 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: kernel: hexagon_ksyms.c remove useless __hexagon_*i3()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only find "DECLARE_EXPORT(__hexagon_*i3)", no related implementations
and callers, so remove them, or will cause ld issue with allmodconfig,
the related error:

    LD      init/built-in.o
  arch/hexagon/kernel/built-in.o:(___ksymtab+__hexagon_umodsi3+0x0): undefined reference to `__hexagon_umodsi3'
  arch/hexagon/kernel/built-in.o:(___ksymtab+__hexagon_udivsi3+0x0): undefined reference to `__hexagon_udivsi3'
  arch/hexagon/kernel/built-in.o:(___ksymtab+__hexagon_modsi3+0x0): undefined reference to `__hexagon_modsi3'
  arch/hexagon/kernel/built-in.o:(___ksymtab+__hexagon_divsi3+0x0): undefined reference to `__hexagon_divsi3'


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/kernel/hexagon_ksyms.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/hexagon/kernel/hexagon_ksyms.c b/arch/hexagon/kernel/hexagon_ksyms.c
index 32b1379..1257c85 100644
--- a/arch/hexagon/kernel/hexagon_ksyms.c
+++ b/arch/hexagon/kernel/hexagon_ksyms.c
@@ -33,8 +33,3 @@ EXPORT_SYMBOL(memset);
 
 /* Symbols found in libgcc that assorted kernel modules need */
 DECLARE_EXPORT(__hexagon_memcpy_likely_aligned_min32bytes_mult8bytes);
-
-DECLARE_EXPORT(__hexagon_divsi3);
-DECLARE_EXPORT(__hexagon_modsi3);
-DECLARE_EXPORT(__hexagon_udivsi3);
-DECLARE_EXPORT(__hexagon_umodsi3);
-- 
1.7.7.6

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3C3TqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 15:46:21 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:46434 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200Ab3C3TqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 15:46:20 -0400
X-Auth-Info: qhwUCy1ZIWmNF/AISGHdXJLflhe3LBLm0mGSHBjQYBU=
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Jon Medhurst \(Tixy\)" <tixy@linaro.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: Re: [BUG] mod/file2alias: build error in devicetable-offsets.c [was: asm/types.h Header file wont get generated while building uImage ?]
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
	<1363949290.3528.37.camel@linaro1.home>
X-Yow: Three attractive BANK ROBBERS are discussing RELIGIOUS DIFFERENCES and
 MAKE-UP TECHNIQUE with them!!
Date: Sat, 30 Mar 2013 20:46:16 +0100
In-Reply-To: <1363949290.3528.37.camel@linaro1.home> (Jon Medhurst's message
	of "Fri, 22 Mar 2013 10:48:10 +0000")
Message-ID: <m2ip48d62f.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jon Medhurst (Tixy)" <tixy@linaro.org> writes:

> For builds which succeed I see this order:
>
>   WRAP    arch/arm/include/generated/asm/types.h
>   [...]
>   GEN     include/generated/asm-offsets.h
>
> and for those which fail:
>
>   CC      scripts/mod/devicetable-offsets.s
>   In file included from include/linux/types.h:5:0,
>                    from include/linux/mod_devicetable.h:11,
>                    from scripts/mod/devicetable-offsets.c:2:
>   include/uapi/linux/types.h:4:23: fatal error: asm/types.h: No such file or directory
>   [...]
>   WRAP    arch/arm/include/generated/asm/types.h

Does that help?

diff --git a/Makefile b/Makefile
index a5f3203..2a484db 100644
--- a/Makefile
+++ b/Makefile
@@ -512,7 +512,8 @@ ifeq ($(KBUILD_EXTMOD),)
 # Carefully list dependencies so we do not try to build scripts twice
 # in parallel
 PHONY += scripts
-scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
+scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
+	 asm-generic
 	$(Q)$(MAKE) $(build)=$(@)
 
 # Objects we will link into vmlinux / subdirs we need to visit

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158Ab3DIR5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:57:06 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39856 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3DIR5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:57:03 -0400
X-Auth-Info: GX71fDZOQ0xPmrKWTJvEX98kt551gMvMnHTfmE9ZlM4=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: "Jon Medhurst \(Tixy\)" <tixy@linaro.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] kbuild: generate generic headers before recursing into
 scripts
References: <CA+V-a8vYsBLVH-3Bm35Sv9K9ZMTcMB4_P_V3kBjyuEKDozPi5w@mail.gmail.com>
	<1363949290.3528.37.camel@linaro1.home> <m2ip48d62f.fsf@igel.home>
	<CA+V-a8srtwdf1H2JQwbkyMFhXopPEA90RM8Hy+UunM6Mm7-d1w@mail.gmail.com>
X-Yow: What's the MATTER Sid?..  Is your BEVERAGE unsatisfactory?
Date: Tue, 09 Apr 2013 19:57:00 +0200
In-Reply-To: <CA+V-a8srtwdf1H2JQwbkyMFhXopPEA90RM8Hy+UunM6Mm7-d1w@mail.gmail.com>
	(Prabhakar Lad's message of "Tue, 9 Apr 2013 17:44:47 +0530")
Message-ID: <m2k3ob1tar.fsf_-_@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The headers are now needed inside scripts/mod since 6543bec
("mod/file2alias: make modalias generation safe for cross compiling").

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
Prabhakar Lad <prabhakar.csengg@gmail.com> writes:

> Whats the status of it ?

I think it has sufficiently been tested by now.

Andreas.
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 6db672b..11157bd 100644
--- a/Makefile
+++ b/Makefile
@@ -513,7 +513,8 @@ ifeq ($(KBUILD_EXTMOD),)
 # Carefully list dependencies so we do not try to build scripts twice
 # in parallel
 PHONY += scripts
-scripts: scripts_basic include/config/auto.conf include/config/tristate.conf
+scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
+	 asm-generic
 	$(Q)$(MAKE) $(build)=$(@)
 
 # Objects we will link into vmlinux / subdirs we need to visit
-- 
1.8.2.1


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

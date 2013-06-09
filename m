Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3FIKHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:07:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47449 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3FIKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:07:37 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/5] Add a safe static_cpu_has variant
Date: Sun,  9 Jun 2013 12:07:29 +0200
Message-Id: <1370772454-6106-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

As recently experienced, using static_cpu_has too early (before
alternatives have run) causes some obscure bugs and decyphering those
doesn't simply point to such premature usage.

Therefore, let's add a static_cpu_has_safe variant which always works
and can be used in early code.

Also, 2/5 adds a debugging option, the idea behind it being to enable
all sensible debugging code which we want to enable on x86 in order to
catch build and runtime issues. The idea is to save a bunch of time of
wading through "Kernel hacking" and staring at options. We'll see how
that actually pans out though.

Borislav Petkov (5):
  x86, cpu: Add a synthetic cpu feature
  x86, debug: Add a collect-all misc debug checks option
  x86: Sanity-check static_cpu_has usage
  x86: Add a static_cpu_has_safe variant
  x86, FPU: Use static_cpu_has_safe before alternatives

 arch/x86/Kconfig.debug              |  12 ++++
 arch/x86/include/asm/cpufeature.h   | 118 ++++++++++++++++++++++++++++++++++--
 arch/x86/include/asm/fpu-internal.h |   2 +-
 arch/x86/kernel/cpu/common.c        |  16 +++++
 4 files changed, 143 insertions(+), 5 deletions(-)

-- 
1.8.3


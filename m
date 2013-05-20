Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3ETEUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 00:20:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:49698 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab3ETEUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 00:20:21 -0400
X-Spam-Score: -100.8
Message-ID: <5199A453.4080402@asianux.com>
Date: Mon, 20 May 2013 12:19:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: compiling issue for allmodconfig, need "asm/parport.h"
 by "drivers/parport/parport_pc.c"
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424102327.GF21850@mudshark.cambridge.arm.com> <5177BAD0.9000500@asianux.com> <20130424110511.GK23397@arm.com>
In-Reply-To: <20130424110511.GK23397@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need add the default file in 'asm/Kbuild' just like arm has done.

The build command is:
  make EXTRA_CFLAGS=-W ARCH=arm64 allmodconfig
  make EXTRA_CFLAGS=-W ARCH=arm64 menuconfig
    set "aarch64-linux-gnu-" as cross compiling prefix.
  make EXTRA_CFLAGS=-W ARCH=arm64

The related error:
  drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 79a642d..9005e81 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -25,6 +25,7 @@ generic-y += local64.h
 generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += mutex.h
+generic-y += parport.h
 generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
-- 
1.7.7.6

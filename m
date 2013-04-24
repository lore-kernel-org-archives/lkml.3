Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3DXK7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:59:12 -0400
Received: from intranet.asianux.com ([58.214.24.6]:58037 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab3DXK7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:59:10 -0400
X-Spam-Score: -100.8
Message-ID: <5177BAD0.9000500@asianux.com>
Date: Wed, 24 Apr 2013 18:58:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] arm64: compiling issue, need add include/asm/vga.h file
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424102327.GF21850@mudshark.cambridge.arm.com>
In-Reply-To: <20130424102327.GF21850@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For compiling with allmodconfig, need vga.h file, so generate it which
just only include the asm-generic one.

It is firstly used by drivers/gpu/drm/drm_irq.c.

The related error:
include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index a13a4a4..79a642d 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -48,4 +48,5 @@ generic-y += trace_clock.h
 generic-y += types.h
 generic-y += unaligned.h
 generic-y += user.h
+generic-y += vga.h
 generic-y += xor.h
-- 
1.7.7.6

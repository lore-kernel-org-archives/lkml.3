Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3LMSaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:30:14 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45103 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3LMSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:30:13 -0500
Message-ID: <52AB522F.8000703@kernelgen.org>
Date: Fri, 13 Dec 2013 19:30:07 +0100
From: Dmitry Mikushin <dmitry@kernelgen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ia32 emulation on Pentium I
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I'm trying to enable ia32 emulation in k1om kernel. Linux kernel is
ported for k1om, but with ia32 emulation disabled. With it enabled,
I'm getting the following error:

LD arch/x86/crypto/built-in.o
AS arch/x86/ia32/ia32entry.o
arch/x86/ia32/ia32entry.S: Assembler messages:
arch/x86/ia32/ia32entry.S:192: Error: `sysexit' is not supported on `k1om'
make[2]: *** [arch/x86/ia32/ia32entry.o] Error 1
make[1]: *** [arch/x86/ia32] Error 2
make: *** [arch/x86] Error 2

sysexit is not supported because k1om (Intel MIC) is essentially Pentium
I with AVX512 extensions.

sysexit is used in macro ENABLE_INTERRUPTS_SYSEXIT32, which is in turn
used in ENTRY(ia32_sysenter_target).

So, it seems ia32 emulation assumes Pentium II+. Do you see a quick
way to make it Pentium I -compatible?

Thanks,
- D.

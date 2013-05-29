Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977Ab3E2CHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:07:07 -0400
Received: from intranet.asianux.com ([58.214.24.6]:39662 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934826Ab3E2CHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:07:05 -0400
X-Spam-Score: -100.8
Message-ID: <51A56296.1090404@asianux.com>
Date: Wed, 29 May 2013 10:06:14 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] arm64: compiling issue for allmodconfig, need "asm/parport.h"
 by "drivers/parport/parport_pc.c"
References: <5177551D.8090007@asianux.com> <20130424082237.GA23397@arm.com> <5177B1F0.10106@asianux.com> <20130424102327.GF21850@mudshark.cambridge.arm.com> <5177BAD0.9000500@asianux.com> <20130424110511.GK23397@arm.com> <5199A453.4080402@asianux.com> <20130521131734.GD27002@arm.com> <519C1539.10908@asianux.com> <519C7484.9020709@asianux.com> <20130528170219.GI17912@arm.com>
In-Reply-To: <20130528170219.GI17912@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 01:02 AM, Catalin Marinas wrote:
>> > 
>> > After check the Kconfig in drivers, we can find quite a few using long
>> > list args which related with ARCH.
>> > 
>> > And they are not only depend on ARCHs, but also depend on another
>> > things (e.g. VGA_CONSOL also depend on !4xx && !8xx, and another
>> > combinations).
> Given this dependency is on the negation of that symbol, you just remove
> it and have a "depends on HAVE_VGA_CONSOLE". The few architectures that
> need it will have to define it (X86, ARM with a few configurations).
> 

it is "depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV &&
!SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE
|| ARCH_INTEGRATOR || ARCH_NETWINDER)"

So, not only x86, ARM, but also s390, xtensa, alpha, cris, h8300, ia64,
mips... (at least, we do not know, they whether need it or not).


>> > We also can find another long list for depend on, but not related with
>> > ARCH.
>> > 
>> > They seems not quit difficult for reading (in fact, if we separate them
>> > into pieces and let them spread into another areas, the reader will not
>> > see the whole dependency clearly)
>> > 
>> > For fixing bug, better as local as possible, as independent as possible,
>> > it will be OK if only add !ARM64 for PARPORT_PC depend on, and it has
>> > no any negative effect. But if we define CONFIG_HAVE_*, we have to let
>> > it related with multiple platforms.
>> > 
>> > For design: if can bear current design, better not to touch it, I think
>> > current design is still sustainable, and not complex for understanding,
>> > so not need redesign.
> We usually clean some of these as we hit them, otherwise people forget
> about the clean-up later ;).

In fact, I have sent another configuration modification about disabling
CONFIG_BUG. it is in discussing...

We are sure most of architectures do not need CONFIG_BUG, but for
VGA_CONSOLE, we can not be sure most of architectures do not need it.

For CONFIG_BUG issue, it will make noisy for most of architectures, but
for VGA_CONSOLE issue, at least now, it is only effect with arm64.

For CONFIG_BUG issue, it seems we can not provide a satisfied fixing if
not get rid of it, but for VGA_CONSOLE issue, at least we have a
complete fixing way for it.


And now for CONFIG_BUG issue, it is still continuing discussing, and it
seems that can not get a result quickly.

So for VGA_CONSOLE... ;-)


Thanks.
-- 
Chen Gang

Asianux Corporation

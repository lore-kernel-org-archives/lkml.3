Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaJ1Bes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:34:48 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16900 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbaJ1Ber convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:34:47 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>
Date: Tue, 28 Oct 2014 09:34:42 +0800
Subject: RE: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Topic: [RFC V3] arm/arm64:add CONFIG_HAVE_ARCH_BITREVERSE to support
 rbit instruction
Thread-Index: Ac/x06hnK3vlP4BiRju1caxUbUunAgAe3XOw
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1825A@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18259@CNBJMBX05.corpusers.net>
 <20141027104848.GD8768@arm.com>
In-Reply-To: <20141027104848.GD8768@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Will Deacon [mailto:will.deacon@arm.com]
> > +++ b/arch/arm/include/asm/bitrev.h
> > @@ -0,0 +1,28 @@
> > +#ifndef __ASM_ARM_BITREV_H
> > +#define __ASM_ARM_BITREV_H
> > +
> > +static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
> > +{
> > +	if (__builtin_constant_p(x)) {
> > +		x = (x >> 16) | (x << 16);
> > +		x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
> > +		x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
> > +		x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
> > +		return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
> > +	}
> > +	__asm__ ("rbit %0, %1" : "=r" (x) : "r" (x));
> 
> I think you need to use %w0 and %w1 here, otherwise you bit-reverse the 64-
> bit register.
For arm64 in arch/arm64/include/asm/bitrev.h.
I have use __asm__ ("rbit %w0, %w1" : "=r" (x) : "r" (x));
For arm , I use __asm__ ("rbit %0, %1" : "=r" (x) : "r" (x));
Am I right ?
Thanks

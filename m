Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbbAIMlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:41:01 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:3349 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419AbbAIMlA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:41:00 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 9 Jan 2015 20:40:56 +0800
Subject: RE: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
Thread-Index: AdAr/PXsSIMtzQSaQvaNR/yTI7onlQACpIuA
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E198@CNBJMBX05.corpusers.net>
References: <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18273@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18275@CNBJMBX05.corpusers.net>
 <20141113235322.GC4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E010D1829B@CNBJMBX05.corpusers.net>
 <20141114095812.GG4042@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103E688B313C6@CNBJMBX05.corpusers.net>
 <20150108184059.GZ12302@n2100.arm.linux.org.uk>
 <35FD53F367049845BC99AC72306C23D103EDAF89E195@CNBJMBX05.corpusers.net>
 <20150109111048.GE12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150109111048.GE12302@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Friday, January 09, 2015 7:11 PM
> To: Wang, Yalin
> Cc: 'Ard Biesheuvel'; 'Will Deacon'; 'linux-kernel@vger.kernel.org';
> 'akinobu.mita@gmail.com'; 'linux-mm@kvack.org'; 'Joe Perches'; 'linux-arm-
> kernel@lists.infradead.org'
> Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit instruction
> 
> On Fri, Jan 09, 2015 at 10:16:32AM +0800, Wang, Yalin wrote:
> > > -----Original Message-----
> > > From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> > > Sent: Friday, January 09, 2015 2:41 AM
> > > To: Wang, Yalin
> > > Cc: 'Will Deacon'; 'Ard Biesheuvel'; 'linux-kernel@vger.kernel.org';
> > > 'akinobu.mita@gmail.com'; 'linux-mm@kvack.org'; 'Joe Perches';
> > > 'linux-arm- kernel@lists.infradead.org'
> > > Subject: Re: [RFC V6 2/3] arm:add bitrev.h file to support rbit
> > > instruction
> > >
> > > The root cause is that the kernel being built is supposed to support
> > > both
> > > ARMv7 and ARMv6K CPUs.  However, "rbit" is only available on
> > > ARMv6T2 (thumb2) and ARMv7, and not plain ARMv6 or ARMv6K CPUs.
> > >
> > In the patch that you applied:
> > 8205/1 	add bitrev.h file to support rbit instruction
> >
> > I have add :
> > +	select HAVE_ARCH_BITREVERSE if ((CPU_V7M || CPU_V7) && !CPU_V6)
> >
> > If you build kernel support ARMv6K, should CONFIG_CPU_V6=y, isn't it ?
> > Then will not build hardware rbit instruction, isn't it ?
> 
> The config has:
> 
> CONFIG_CPU_PJ4=y
> # CONFIG_CPU_V6 is not set
> CONFIG_CPU_V6K=y
> CONFIG_CPU_V7=y
> CONFIG_CPU_32v6=y
> CONFIG_CPU_32v6K=y
> CONFIG_CPU_32v7=y
> 
> And no, the CONFIG_CPU_V* flags refer to the CPUs.  The
> CONFIG_CPU_32v* symbols refer to the CPU architectures.
> 
Oh, I see,
How about change like this:
+	select HAVE_ARCH_BITREVERSE if ((CPU_V7M || CPU_V7) && !CPU_V6 && !CPU_V6K)
I am not sure if I also need add some older CPU types like !CPU_ARM9TDMI &&　!CPU_ARM940T ?

Another solution is:
+	select HAVE_ARCH_BITREVERSE if ((CPU_32V7M || CPU_32V7) && !CPU_32V6 && !CPU_32V5 && !CPU_32V4 && !CPU_32V4T && !CPU_32V3)

By the way, I am not clear about the difference between CPU_V6 and CPU_V6K, could you tell me? :)

Thank you 








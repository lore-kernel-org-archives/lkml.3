Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161667AbaJaCDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:03:33 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:6300 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161511AbaJaCDc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:03:32 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'Rob Herring'" <robherring2@gmail.com>, "'Joe Perches'" <joe@perches.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 10:03:27 +0800
Subject: RE: [RFC V5 3/3] arm64:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V5 3/3] arm64:add bitrev.h file to support rbit
 instruction
Thread-Index: Ac/0OUvUEsbSUvy4Q6WQKZzfEzbjXgAdXQcQ
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1826F@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D18254@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18257@CNBJMBX05.corpusers.net>
 <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
In-Reply-To: <20141030120127.GC32589@arm.com>
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
> Sent: Thursday, October 30, 2014 8:01 PM
> To: Wang, Yalin
> Cc: 'Rob Herring'; 'Joe Perches'; 'Russell King - ARM Linux'; 'linux-
> kernel@vger.kernel.org'; 'akinobu.mita@gmail.com'; 'linux-mm@kvack.org';
> 'linux-arm-kernel@lists.infradead.org'
> Subject: Re: [RFC V5 3/3] arm64:add bitrev.h file to support rbit
> instruction
> 
> > +static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
> > +{
> > +	if (__builtin_constant_p(x)) {
> > +		x = (x >> 16) | (x << 16);
> > +		x = ((x & 0xFF00FF00) >> 8) | ((x & 0x00FF00FF) << 8);
> > +		x = ((x & 0xF0F0F0F0) >> 4) | ((x & 0x0F0F0F0F) << 4);
> > +		x = ((x & 0xCCCCCCCC) >> 2) | ((x & 0x33333333) << 2);
> > +		return ((x & 0xAAAAAAAA) >> 1) | ((x & 0x55555555) << 1);
> 
> Shouldn't this part be in the generic code?

Good  idea, I will change this part into linux/bitrev.h .
Thanks

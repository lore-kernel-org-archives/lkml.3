Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaCUOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:15:54 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60119 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751786AbaCUOPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:15:51 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Patrick McHardy <kaber@trash.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H.K. Jerry Chu" <hkchu@google.com>,
        "Michael Dalton" <mwdalton@google.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] csum experts, csum_replace2() is too expensive
Thread-Topic: [RFC] csum experts, csum_replace2() is too expensive
Thread-Index: AQHPRQQeGDrZTVBHAkePrJRr0yADAZrrifJQ
Date: Fri, 21 Mar 2014 14:14:23 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E557E@AcuExch.aculab.com>
References: <1395341341.9114.93.camel@edumazet-glaptop2.roam.corp.google.com>
	 <87a9cknwk4.fsf@tassilo.jf.intel.com>
 <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2LEG3mq000440

From: Eric Dumazet
> On Thu, 2014-03-20 at 18:56 -0700, Andi Kleen wrote:
> > Eric Dumazet <eric.dumazet@gmail.com> writes:
> > >
> > > I saw csum_partial() consuming 1% of cpu cycles in a GRO workload, that
> > > is insane...
> >
> >
> > Couldn't it just be the cache miss?
> 
> Or the fact that we mix 16 bit stores and 32bit loads ?
> 
> BTW, any idea why ip_fast_csum() on x86 contains a "memory" constraint ?

The correct constraint would be one that told gcc that it
accesses the 20 bytes from the source pointer.

Without it gcc won't necessarily write out the values before
the asm instructions execute.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

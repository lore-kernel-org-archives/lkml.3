Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaCXKa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 06:30:58 -0400
Received: from mx0.aculab.com ([213.249.233.131]:56003 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750998AbaCXKa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 06:30:56 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "kaber@trash.net" <kaber@trash.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "hkchu@google.com" <hkchu@google.com>,
        "mwdalton@google.com" <mwdalton@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC] csum experts, csum_replace2() is too expensive
Thread-Topic: [RFC] csum experts, csum_replace2() is too expensive
Thread-Index: AQHPRTa1GDrZTVBHAkePrJRr0yADAZrvjR0AgAB/ZWA=
Date: Mon, 24 Mar 2014 10:30:19 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E77A4@AcuExch.aculab.com>
References: <1395341341.9114.93.camel@edumazet-glaptop2.roam.corp.google.com>
	 <87a9cknwk4.fsf@tassilo.jf.intel.com>
	 <1395406250.9114.142.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140321.145229.1026128975151125729.davem@davemloft.net>
 <1395629410.9117.46.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1395629410.9117.46.camel@edumazet-glaptop2.roam.corp.google.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2OAVEUK014351

From: Eric Dumazet
> On Fri, 2014-03-21 at 14:52 -0400, David Miller wrote:
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Fri, 21 Mar 2014 05:50:50 -0700
> >
> > > It looks like a barrier() would be more appropriate.
> >
> > barrier() == __asm__ __volatile__(:::"memory")
> 
> Indeed, but now you mention it, ip_fast_csum() do not uses volatile
> keyword on x86_64, and has no "m" constraint either.

Adding 'volatile' isn't sufficient to force gcc to write data
into the area being checksummed.
ip_fast_csum() either needs an explicit "m" constraint for the actual
buffer (and target) bytes, or the stronger "memory" constraint.
The 'volatile' is then not needed.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

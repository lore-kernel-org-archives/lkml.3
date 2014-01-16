Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaAPJau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:30:50 -0500
Received: from mx0.aculab.com ([213.249.233.131]:48266 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752246AbaAPJap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:30:45 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: RE: [PATCH net-next 1/2] random32: add prandom_u32_lt_N and convert
 "misuses" of reciprocal_divide
Thread-Topic: [PATCH net-next 1/2] random32: add prandom_u32_lt_N and
 convert "misuses" of reciprocal_divide
Thread-Index: AQHPEnTDLEe58ej+DkOnUyMNeJ8BfJqHE+Ew
Date: Thu, 16 Jan 2014 09:28:33 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45D899@AcuExch.aculab.com>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
	 <1389828228-30312-2-git-send-email-dborkman@redhat.com>
 <1389842050.31367.396.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1389842050.31367.396.camel@edumazet-glaptop2.roam.corp.google.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G9Ut33016548

From: Eric Dumazet
> On Thu, 2014-01-16 at 00:23 +0100, Daniel Borkmann wrote:
> 
> > @@ -1220,7 +1219,7 @@ static unsigned int fanout_demux_hash(struct packet_fanout *f,
> >  				      struct sk_buff *skb,
> >  				      unsigned int num)
> >  {
> > -	return reciprocal_divide(skb->rxhash, num);
> > +	return (u32)(((u64) skb->rxhash * num) >> 32);
> >  }
> >
> 
> This is unfortunate.
> 
> (This reverts one of your patch : f55d112e529386 )
> 
> Please add a helper to explain what's going on here, and on many other
> spots we do this computation (as in get_rps_cpu()).
> Few people really understand this.
> 
> Or keep reciprocal_divide() as is, and introduce a new set of functions
> for people really wanting the precise divides.

Maybe rename the current reciprocal_divide() as well?

In the above code it isn't immediately obvious that the result of
a division is as useful as that of a modulus!
OTOH the high 32 bits of a 32x32 multiply are (slightly) more obviously
in the required range.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

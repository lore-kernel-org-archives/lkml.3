Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaAQKIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:08:05 -0500
Received: from mx0.aculab.com ([213.249.233.131]:39710 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752471AbaAQKH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:07:57 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Hannes Frederic Sowa'" <hannes@stressinduktion.org>,
        Christoph Lameter <cl@linux.com>
CC: Daniel Borkmann <dborkman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "Jesse Gross" <jesse@nicira.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        Matt Mackall <mpm@selenic.com>, "Pekka Enberg" <penberg@kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "Veaceslav Falico" <vfalico@redhat.com>,
        Jay Vosburgh <fubar@us.ibm.com>,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>
Subject: RE: [PATCH net-next 2/2] reciprocal_divide: correction/update of
 the algorithm
Thread-Topic: [PATCH net-next 2/2] reciprocal_divide: correction/update of
 the algorithm
Thread-Index: AQHPEt98Z7WBrBo+/0up6rnEAEb4SpqIsDOQ
Date: Fri, 17 Jan 2014 10:05:37 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45EB06@AcuExch.aculab.com>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
 <1389828228-30312-3-git-send-email-dborkman@redhat.com>
 <alpine.DEB.2.10.1401161036110.29778@nuc>
 <20140116172406.GA17529@order.stressinduktion.org>
In-Reply-To: <20140116172406.GA17529@order.stressinduktion.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HA8FX9023755

From: Hannes Frederic Sowa
> On Thu, Jan 16, 2014 at 10:37:37AM -0600, Christoph Lameter wrote:
> > On Thu, 16 Jan 2014, Daniel Borkmann wrote:
> >
> > > - * or else the performance is slower than a normal divide.
> > > - */
> > > -extern u32 reciprocal_value(u32 B);
> > > +struct reciprocal_value {
> > > +	u32 m;
> > > +	u8 sh1, sh2;
> > > +};
> > >
> > > +#define RECIPROCAL_VALUE_RESULT_TO_ZERO ((struct reciprocal_value){.sh1 = 32})
> > >
> > > -static inline u32 reciprocal_divide(u32 A, u32 R)
> > > +struct reciprocal_value reciprocal_value(u32 d);
> >
> > A function that returns a struct? That works? Which gcc versions support
> > it?
> 
> Sure, that works and I actually like it. This is supported by the c standard,
> but please don't ask me since which one. ;)

I think it has always been supported.
Originally by adding an extra hidden argument that points to an on-stack
structure.
More recent ABI tend to allow 'small' structures be returned in registers.
(Typically ones that would fit in the register(s) used for an integral result).

This doesn't mean that it is a good idea!

OTOH if the function is 'static inline' (and inlined) it probably doesn't matter.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

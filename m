Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaI3LUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:20:41 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52922 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751044AbaI3LUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:20:40 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Hannes Frederic Sowa'" <hannes@redhat.com>
CC: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Tom Herbert <therbert@google.com>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>,
        "stephen hemminger" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] tun: make sure interface usage can not overflow
Thread-Topic: [PATCH] tun: make sure interface usage can not overflow
Thread-Index: AQHP23O5ZibDxwfCgkiMJV4jx9aoxJwX8m+wgACAiwCAAAakAIAA3UnggAAd04CAABQcYA==
Date: Tue, 30 Sep 2014 11:18:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174A0ECF@AcuExch.aculab.com>
References: <20140928232753.GA31180@www.outflux.net>
	 <063D6719AE5E284EB5DD2968C1650D6D1749FC70@AcuExch.aculab.com>
	 <CAGXu5jKL13qdCBet3yqpc3vLYh_LifBACzL+NP8n-A+E8RMZXw@mail.gmail.com>
	 <1412021098.14757.6.camel@localhost>
	 <063D6719AE5E284EB5DD2968C1650D6D174A0C5C@AcuExch.aculab.com>
 <1412075023.7155.21.camel@localhost>
In-Reply-To: <1412075023.7155.21.camel@localhost>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8UBKtx8021367

From: Hannes Frederic 
> On Di, 2014-09-30 at 08:20 +0000, David Laight wrote:
> > From: Hannes Frederic
> > > On Mo, 2014-09-29 at 12:41 -0700, Kees Cook wrote:
> > > > On Mon, Sep 29, 2014 at 4:04 AM, David Laight <David.Laight@aculab.com> wrote:
> > > > > From: Kees Cook
> > > > >> This makes the size argument a const, since it is always populated by
> > > > >> the caller.
> > > > >
> > > > > There is almost no point making parameters 'const.
> > > > > ('const foo *' makes sense).
> > > > >
> > > > >> Additionally double-checks to make sure the copy_from_user
> > > > >> can never overflow, keeping CONFIG_DEBUG_STRICT_USER_COPY_CHECKS happy:
> > > > >>
> > > > >>    In function 'copy_from_user',
> > > > >>        inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1871:7:
> > > > >>        ... copy_from_user() buffer size is not provably correct
> > > > >
> > > > > If 'ifreq_len' could be too big then you want to error the ioctl, not panic.
> > > > > If it can't be too big you don't need the check.
> > > >
> > > > The ifreq_len comes from the callers, and is the output of "sizeof"
> > > > which is const. Changing the function parameter to "const" means any
> > > > changes made in the future where the incoming value isn't const, the
> > > > compiler will throw a warning.
> > >
> > > Hmmm, I think you want something like BUILD_BUG_ON(!
> > > __builtin_constant_p(var)). const in function argument only ensures that
> > > the value cannot be modified in the function.
> >
> > You'd have to do something in the header file - nothing in the function
> > body can do that check.
> 
> Sure, it should work. You only need to make sure that gcc inlines the
> function, so the value is constant (it is not enough that gcc knows the
> value range, one specific constant is needed). So the simplest fix for
> this is to specify __tun_chr_ioctl as __always_inline. ;)

You are joking aren't you???

Look at the code.

I'd suggest fixing whatever implements CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
to be less picky.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

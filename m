Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaI3IWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:22:19 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47968 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751399AbaI3IWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:22:16 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Hannes Frederic Sowa'" <hannes@redhat.com>,
        Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Tom Herbert" <therbert@google.com>,
        Masatake YAMATO <yamato@redhat.com>, Xi Wang <xii@google.com>,
        stephen hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] tun: make sure interface usage can not overflow
Thread-Topic: [PATCH] tun: make sure interface usage can not overflow
Thread-Index: AQHP23O5ZibDxwfCgkiMJV4jx9aoxJwX8m+wgACAiwCAAAakAIAA3Ung
Date: Tue, 30 Sep 2014 08:20:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174A0C5C@AcuExch.aculab.com>
References: <20140928232753.GA31180@www.outflux.net>
	 <063D6719AE5E284EB5DD2968C1650D6D1749FC70@AcuExch.aculab.com>
	 <CAGXu5jKL13qdCBet3yqpc3vLYh_LifBACzL+NP8n-A+E8RMZXw@mail.gmail.com>
 <1412021098.14757.6.camel@localhost>
In-Reply-To: <1412021098.14757.6.camel@localhost>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U8MPif020322

From: Hannes Frederic
> On Mo, 2014-09-29 at 12:41 -0700, Kees Cook wrote:
> > On Mon, Sep 29, 2014 at 4:04 AM, David Laight <David.Laight@aculab.com> wrote:
> > > From: Kees Cook
> > >> This makes the size argument a const, since it is always populated by
> > >> the caller.
> > >
> > > There is almost no point making parameters 'const.
> > > ('const foo *' makes sense).
> > >
> > >> Additionally double-checks to make sure the copy_from_user
> > >> can never overflow, keeping CONFIG_DEBUG_STRICT_USER_COPY_CHECKS happy:
> > >>
> > >>    In function 'copy_from_user',
> > >>        inlined from '__tun_chr_ioctl' at drivers/net/tun.c:1871:7:
> > >>        ... copy_from_user() buffer size is not provably correct
> > >
> > > If 'ifreq_len' could be too big then you want to error the ioctl, not panic.
> > > If it can't be too big you don't need the check.
> >
> > The ifreq_len comes from the callers, and is the output of "sizeof"
> > which is const. Changing the function parameter to "const" means any
> > changes made in the future where the incoming value isn't const, the
> > compiler will throw a warning.
> 
> Hmmm, I think you want something like BUILD_BUG_ON(!
> __builtin_constant_p(var)). const in function argument only ensures that
> the value cannot be modified in the function.

You'd have to do something in the header file - nothing in the function
body can do that check.

I've not got the source handy, but in this case is there any need to
actually pass the size at all?
Is it always the same fixed constant??

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

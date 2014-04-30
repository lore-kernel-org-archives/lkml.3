Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbaD3J7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:59:40 -0400
Received: from mx0.aculab.com ([213.249.233.131]:36151 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754283AbaD3J7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:59:38 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jan Moskyto Matejka'" <mq@suse.cz>, Alexey Charkov <alchark@gmail.com>
CC: Roger Luethi <rl@hellgate.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: via-rhine: fix compiler warning
Thread-Topic: [PATCH] net: via-rhine: fix compiler warning
Thread-Index: AQHPY9FWWp1qfKJ7c0OzzdAVAe6qrZsp2FVQ///6yYCAAAengIAAEajA
Date: Wed, 30 Apr 2014 09:57:40 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F702D55@AcuExch.aculab.com>
References: <1398792971-10379-1-git-send-email-mq@suse.cz>
 <063D6719AE5E284EB5DD2968C1650D6D0F702C5F@AcuExch.aculab.com>
 <CABjd4YzRTPcy1nbhywuNLb0pz4gPVjhzegZJTc_g+_SVc1XJvw@mail.gmail.com>
 <20140430095015.GC24832@moskyto.dyndns.org>
In-Reply-To: <20140430095015.GC24832@moskyto.dyndns.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3U9xoEX006546

From: Jan Moskyto Matejka
> > > So why not just:
> > >         revision = (unsigned long)match->data;
> > > and add a comment that the 0x84 is the revision - #define ??
> >
> > There is no particular reason why it should be u32 now - this is a
> > leftover from the previous iteration of code where revision was a
> > separate property in DT (sized u32). It actually mirrors the
> > respective field in struct pci_dev, which is u8 - don't see any issue
> > defining it as unsigned long (and also changing the definition in
> > struct rhine_private).
> >
> > The comment that it's the revision is right above the match table (cut
> > off in the patch) :)
> >
> > Jan, would you prefer to adjust your patch, or shall I send another
> > one to change rp->revision and friends to unsigned long?
> 
> I prefer you to make another patch, you obviously know more about this
> driver. Also thanks for suggesting (void*)->(unsigned long), I didn't
> know that these two are defined to have the same size (in kernel code).

The kernel assumes that throughout - the double cast is common.
The C99 type is uintptr_t - but I don't think that is defined in kernel.
The only place I know where sizeof (long) != sizeof (void *) is 64bit
windows. So anyone trying to compile a linux driver to run in the
windows kernel might have issues (never mind the GPL ones).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

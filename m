Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbaCUJX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:23:27 -0400
Received: from mx0.aculab.com ([213.249.233.131]:54183 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751488AbaCUJXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:23:23 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Scott Wood'" <scottwood@freescale.com>
CC: "'Kevin Hao'" <haokexin@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Chenhui Zhao <chenhui.zhao@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Thread-Topic: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Thread-Index: AQHPRDIhfWL8RcQP30utVc0r+VRreZrp3JdQgACsuYCAALfRUA==
Date: Fri, 21 Mar 2014 09:21:56 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E40C4@AcuExch.aculab.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
	 <1394586624.13761.132.camel@snotra.buserror.net>
	 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
	 <1394646185.13761.145.camel@snotra.buserror.net>
	 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
	 <1394835987.12479.119.camel@snotra.buserror.net>
	 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
	 <1395184734.12479.250.camel@snotra.buserror.net>
	 <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6E33AE@AcuExch.aculab.com>
 <1395353279.12479.335.camel@snotra.buserror.net>
In-Reply-To: <1395353279.12479.335.camel@snotra.buserror.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2L9NX3j030947

From: Scott Wood [mailto:scottwood@freescale.com]
> On Thu, 2014-03-20 at 11:59 +0000, David Laight wrote:
> > I tried to work out what the 'twi, isync' instructions were for (in in_le32()).
> > The best I could come up with was to ensure a synchronous bus-fault.
> > But bus faults are probably only expected during device probing - not
> > normal operation, and the instructions will have a significant cost.
> >
> > Additionally in_le32() and out_le32() both start with a 'sync' instruction.
> > In many cases that isn't needed either - an explicit iosync() can be
> > used after groups of instructions.
> 
> The idea is that it's better to be maximally safe by default, and let
> performance critical sections be optimized using raw accessors and
> explicit synchronization if needed, than to have hard-to-debug bugs due
> to missing/wrong sync.  A lot of I/O is slow enough that the performance
> impact doesn't really matter, but the brain-time cost of getting the
> sync right is still there.

Hmmm....

That might be an excuse for the 'sync', but not the twi and isync.

I was setting up a dma request (for the ppc 83xx PCIe bridge) and
was doing back to back little-endian writes into memory.
I had difficulty finding and including header files containing
the definitions for byteswapped accesses I needed.
arch/powerpc/include/asm/swab.h contains some - but I couldn't
work out how to get it included (apart from giving the full path).

In any case you need to understand when synchronisation is
required - otherwise you will get it wrong.
Especially since non-byteswapped accesses are done by direct
access.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

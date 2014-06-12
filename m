Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbaFLJnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:43:55 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48633 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932798AbaFLJnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:43:49 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jim Baxter'" <jim_baxter@mentor.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1 3/3] usb: gadget: NCM: Stop RX TCP Bursts getting
 dropped.
Thread-Topic: [PATCH v1 3/3] usb: gadget: NCM: Stop RX TCP Bursts getting
 dropped.
Thread-Index: AQHPhiH1x7PDwcbVCkCd2IQNd3EwhZttON2w
Date: Thu, 12 Jun 2014 09:42:54 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1725B9CA@AcuExch.aculab.com>
References: <Jim Baxter <jim_baxter@mentor.com>
	 <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
	 <1401383543-10181-4-git-send-email-jim_baxter@mentor.com>
 <1401390263.3645.51.camel@edumazet-glaptop2.roam.corp.google.com>
 <53886ABC.8030303@mentor.com> <53997503.7040109@mentor.com>
In-Reply-To: <53997503.7040109@mentor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5C9i24q004673

From: Jim Baxter
> On 30/05/14 12:25, Jim Baxter wrote:
> > On 29/05/14 20:04, Eric Dumazet wrote:
> >> On Thu, 2014-05-29 at 18:12 +0100, Jim Baxter wrote:
> >>
> >> Note the patch is OK, but changelog a bit misleading ;)
> >>
> >> Kernel was not running out of memory, because truesize was correct.
> >>
> >> The problem here is that a frame was consuming more kernel memory than
> >> really needed, so chances of hitting socket sk_rcvbuf limit was high.
> >>
> >> BTW :
> >> #define NTB_OUT_SIZE              16384
> >>
> >> alloc_skb(size) ->
> >> 	kmalloc(16384 + sizeof(struct skb_shared_info)) ->
> >> 		roundup() => 32768
> >>
> >> So truesize of the skb was infact ~32KB, which is really insane indeed.
> >> After your patch, its back to ~2KB
> >>
> >> Acked-by: Eric Dumazet <edumazet@google.com>
> >>
> >>
> >>
> >
> > Thank you, I will clarify the description.
> >
> > Jim
> >
> 
> Hi Eric,
> 
> Is this commit log more correct?
> 
> 
> This fixes a problem with dropped packets over 16k CDC-NCM
> when the connection is being heavily used.
> 
> The issue was that the extracted frames cloned from the
> received frame were consuming more memory than necessary
> due to the truesize being ~32KB instead of ~2KB, this
> meant there was a high chance of reaching the sk_rcvbuf
> limit.

s/due to/resulting in/

	David

> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jim Baxter <jim_baxter@mentor.com>
> 
> Thank you,
> Jim

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

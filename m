Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3LSKD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:03:29 -0500
Received: from mx0.aculab.com ([213.249.233.131]:48226 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751934Ab3LSKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:03:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Date: Thu, 19 Dec 2013 10:01:54 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B74AF@saturn3.aculab.com>
In-Reply-To: <52B2648C.80500@asix.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/1] AX88179_178A: Add FLAG_HW_IPALIGN to determine whether reserving NET_IP_ALIGN bytes for an SKB.
Thread-Index: Ac78aEA2+m8f3aYMTmyGPCMZDkMGmgAOKbqw
References: <1386926708-2343-1-git-send-email-freddy@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B748A@saturn3.aculab.com> <52AEA3A8.2020906@asix.com.tw> <AE90C24D6B3A694183C094C60CF0A2F6026B7490@saturn3.aculab.com> <52B2648C.80500@asix.com.tw>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Freddy Xin" <freddy@asix.com.tw>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <louis@asix.com.tw>,
        <allan@asix.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJA3aLd020087

> From: Freddy Xin
> On 2013å¹´12æœˆ16æ—¥ 18:09, David Laight wrote:
> >> I was thinking of something like: skb = netdev_alloc_skb(dev, length
> >> + dev->skb_align, gfp); if (NET_IP_ALIGN && skb && !(ev->driver_flags
> >> & FLAG_HW_IPALIGN)) skb_reserve(skb, NET_IP_ALIGN); It might even be
> >> reasonable to remove the length adjustment - provided that all the
> >> later code uses the skb length. David
> 
> Thanks for your advice.
> In the way you advised, does the dev->skb_align equal
> to NET_IP_ALIGN in the case that HW doesn't supoort
> IP alignment?

Yes

> In other words, dev->skb_align should be initialized to
> NET_IP_ALIGN in USBNET, and I can change its value to
> 0 in AX88179_178A driver, right?

I'd probably set a flag to request that usbnet set the offset
to the correct value. That makes the initialisation a bit clearer.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

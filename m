Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaLBKAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:00:40 -0500
Received: from mx0.aculab.com ([213.249.233.131]:49897 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751310AbaLBKAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:00:38 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jason Wang'" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC: "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pagupta@redhat.com" <pagupta@redhat.com>
Subject: RE: [PATCH RFC v4 net-next 0/5] virtio_net: enabling tx interrupts
Thread-Topic: [PATCH RFC v4 net-next 0/5] virtio_net: enabling tx interrupts
Thread-Index: AQHQDd5DHvRvdWthCEWkhNyyod07HJx8ETyg
Date: Tue, 2 Dec 2014 10:00:06 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA007CC@AcuExch.aculab.com>
References: <1417429028-11971-1-git-send-email-jasowang@redhat.com>
	<20141201104223.GB16108@redhat.com> <1417490120.4405.2@smtp.corp.redhat.com>
In-Reply-To: <1417490120.4405.2@smtp.corp.redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB2A0ldY015760

From: Jason Wang
> > On Mon, Dec 01, 2014 at 06:17:03PM +0800, Jason Wang wrote:
> >>  Hello:
> >>
> >>  We used to orphan packets before transmission for virtio-net. This
> >> breaks
> >>  socket accounting and can lead serveral functions won't work, e.g:
> >>
> >>  - Byte Queue Limit depends on tx completion nofication to work.
> >>  - Packet Generator depends on tx completion nofication for the last
> >>    transmitted packet to complete.
> >>  - TCP Small Queue depends on proper accounting of sk_wmem_alloc to
> >> work.
> >>
> >>  This series tries to solve the issue by enabling tx interrupts. To
> >> minize
> >>  the performance impacts of this, several optimizations were used:
> >>
> >>  - In guest side, virtqueue_enable_cb_delayed() was used to delay the tx
> >>    interrupt untile 3/4 pending packets were sent.

Doesn't that give problems for intermittent transmits?

...

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaJGOYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:24:35 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49856 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753478AbaJGOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:24:33 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: =?utf-8?B?J0xvdGhhciBXYcOfbWFubic=?= <LW@KARO-electronics.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Frank Li <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Topic: [PATCH] net: fec: fix regression on i.MX28 introduced by
 rx_copybreak support
Thread-Index: AQHP4jE2m8o16PSYfUeOu2GPn2nYPZwkoTOQ///8YQCAABF2YA==
Date: Tue, 7 Oct 2014 14:23:02 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D174C60B1@AcuExch.aculab.com>
References: <1412687977-11742-1-git-send-email-LW@KARO-electronics.de>
	<063D6719AE5E284EB5DD2968C1650D6D174C6025@AcuExch.aculab.com>
 <20141007161702.7cd1e800@ipc1.ka-ro>
In-Reply-To: <20141007161702.7cd1e800@ipc1.ka-ro>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97EOdnn017076

From: Lothar
> David Laight wrote:
> > From: Lothar WaÃŸmann
> > > commit 1b7bde6d659d ("net: fec: implement rx_copybreak to improve rx performance")
> > > introduced a regression for i.MX28. The swap_buffer() function doing
> > > the endian conversion of the received data on i.MX28 may access memory
> > > beyond the actual packet size in the DMA buffer. fec_enet_copybreak()
> > > does not copy those bytes, so that the last bytes of a packet may be
> > > filled with invalid data after swapping.
> > > This will likely lead to checksum errors on received packets.
> > > E.g. when trying to mount an NFS rootfs:
> > > UDP: bad checksum. From 192.168.1.225:111 to 192.168.100.73:44662 ulen 36
> > >
> > > Do the byte swapping and copying to the new skb in one go if
> > > necessary.
> >
> > ISTM that if you need to do the 'swap' you should copy the data regardless
> > of the length.
> >
> The swap function has to look at at most 3 bytes beyond the actual
> packet length. That is what the original swap_buffer() function does and
> what the new function swap_buffer2(), that does the endian swapping
> while copying to the new buffer, also does.

I understood the bug.

The point I was making is that if you have to do a read-write of the received
data (to byteswap it) then you might as well always copy it into a new skb that
is just big enough for the actual receive frame.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

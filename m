Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaCDPOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:14:30 -0500
Received: from mx0.aculab.com ([213.249.233.131]:49830 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932217AbaCDPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:14:28 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Eric Dumazet'" <eric.dumazet@gmail.com>
CC: "'hayeswang'" <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nic_swsd@realtek.com" <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 08/12] r8152: support TSO
Thread-Topic: [PATCH net-next 08/12] r8152: support TSO
Thread-Index: AQHPN6ICLRomJZLUN0ak16x5aFoKeJrQ1RDAgAAOULCAABdMwIAAC5iAgAABz0A=
Date: Tue, 4 Mar 2014 15:14:01 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D0334@AcuExch.aculab.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	 <1393934464-23675-9-git-send-email-hayeswang@realtek.com>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6CFFE0@AcuExch.aculab.com>
	 <CF9EF717568D49DB858D5363B1099FC0@realtek.com.tw>
	 <063D6719AE5E284EB5DD2968C1650D6D0F6D0284@AcuExch.aculab.com>
 <1393945351.26794.110.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1393945351.26794.110.camel@edumazet-glaptop2.roam.corp.google.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s24FEeoh004461

From: Eric Dumazet 
> On Tue, 2014-03-04 at 14:35 +0000, David Laight wrote:
> 
> > Does that mean you are splitting the 64k 'ethernet packet' from TCP
> > is software? I've looked at the ax88179 where the hardware can do it.
> >
> > Is there really a gain doing segmentation here if you have to do the
> > extra data copy?
> 
> There is no 'extra' copy.
> 
> There is _already_ a copy, so what's the deal of doing this copy in a SG
> enabled way ?

Ok.

But there is one more copy than for a normal ethernet chipset which
can use multiple ring entries to send the MAC+IP+TCP headers from a
different buffer to the TCP userdata.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

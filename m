Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaBMLtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:49:24 -0500
Received: from mx0.aculab.com ([213.249.233.131]:36215 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752875AbaBMLtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:49:22 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Emil Goode'" <emilgoode@gmail.com>,
        =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: Steve Glendinning <steve.glendinning@shawell.net>,
        Oliver Neukum <oneukum@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Freddy Xin <freddy@asix.com.tw>, Eric Dumazet <edumazet@google.com>,
        Ming Lei <ming.lei@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>,
        Liu Junliang <liujunliang_ljl@163.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usbnet: remove generic hard_header_len check
Thread-Topic: [PATCH] usbnet: remove generic hard_header_len check
Thread-Index: AQHPKK1QmdnD2dJ0AkaYKWW3k5vKYpqzEAFA
Date: Thu, 13 Feb 2014 11:49:03 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BEB0A@AcuExch.aculab.com>
References: <1392249836-27151-1-git-send-email-emilgoode@gmail.com>
 <87fvnn4c2k.fsf@nemi.mork.no> <20140213112016.GA4245@lianli>
In-Reply-To: <20140213112016.GA4245@lianli>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1DBngjl027077

From: Emil Goode
> > >  int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
> > >  {
> > > +	/* This check is no longer done by usbnet */
> > > +	if (skb->len < dev->net->hard_header_len)
> > > +		return 0;
> > > +
> >
> > Wouldn't it be better to test against ETH_HLEN, since that is a constant
> > and "obviously correct" in this case?
> 
> Some minidrivers change the default hard_header_len value so using it
> guarantees that the patch will not make any change to how the code is
> currently working. Using ETH_HLEN could be more informative about what
> the minidriver should check before passing skbs to usbnet_skb_return().
> Then I think the comment should be changed as well. My intention was to
> not make any changes that affect how the code works for devices I cannot
> test, but I think either way is fine and if you insist on changing it
> let me know.

I think that test is to ensure that the data passed to the mini-driver
contains the ethernet frame encapsulation header (this typically
contains the actual frame length and some flags) so that the minidriver
won't read off the end of the usb data.

Any check for stupidly short ethernet frames would be later on.
IIRC the absolute minimum 802.3 ethernet frame is 17 bytes
(after frame padding has been stripped).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

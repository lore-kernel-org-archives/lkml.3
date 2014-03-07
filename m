Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaCGQKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:10:50 -0500
Received: from mx0.aculab.com ([213.249.233.131]:36366 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752591AbaCGQKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:10:47 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
CC: "'Mathias Nyman'" <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] Revert "xhci 1.0: Limit arbitrarily-aligned scatter
 gather."
Thread-Topic: [PATCH 1/2] Revert "xhci 1.0: Limit arbitrarily-aligned
 scatter gather."
Thread-Index: AQHPOhWgbeh2OUSVo0Cyj0vVCN9CQ5rVu4bwgAAIbACAAAYsMA==
Date: Fri, 7 Mar 2014 16:10:09 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6D796D@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F6D771D@AcuExch.aculab.com>
 <Pine.LNX.4.44L0.1403071043020.1246-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1403071043020.1246-100000@iolanthe.rowland.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s27GB0Yl002785

From: Alan Stern
> On Fri, 7 Mar 2014, David Laight wrote:
> 
> > From: Mathias Nyman
> > > This reverts commit 247bf557273dd775505fb9240d2d152f4f20d304.
> >
> > You need to revert further.
> > Just don?t set hcd->self.no_sg_constraint ever - since it just
> > doesn't work.
> 
> No; it does work most of the time.
> 
> If hcd->self.no_sg_constraint wasn't sent, then certain commands would
> fail always, instead of failing occasionally.

The point is that the no_sg_constraint was added in order to allow
the ax88179_178a driver to send arbitrarily aligned transfers.
Nothing else looks at it (well didn't when I scanned the tree a while back).

In effect all the other transfer requests were assumed to be suitably
aligned.

The check that caused things to fail was the one added to xhci relatively
recently that verified the alignment of the fragments.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

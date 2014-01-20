Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaATLWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:22:43 -0500
Received: from mx0.aculab.com ([213.249.233.131]:47496 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751853AbaATLWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:22:41 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'walt'" <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Index: AQHPELhlWPjDYPI+s0G+DC1zL1oFlJqEeIcAgABE3oCABEGkcIAB9dCAgAKL5bA=
Date: Mon, 20 Jan 2014 11:21:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
In-Reply-To: <52DAE2BF.7020208@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0KBMlVC003177

From: walt 
> On 01/17/2014 06:34 AM, David Laight wrote:
> 
> > Can you try the patch I posted that stops the ownership on LINK TRBs
> > being changed before that on the linked-to TRB?
> 
> Please disregard my earlier post about the patch not applying cleanly.
> That was the usual html corruption, so I found the original on the usb
> list and it was okay.
> 
> Sadly, the patch didn't fix the ASMedia lockup behavior, however :(
> 
> I did notice that the lockup occurred only when copying *to* the usb3
> drive, and not when copying from it.  I think that may be new behavior
> but I can't swear to it.

Consistent with another report that says that ethernet worked provided
that TSO was disabled (ie no sg tx).
(Without the patch to delay he ownership change on link trbs it didn't
work at all.)

A guess...

In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
of xhci_td_remainder().

You can try that on top of either of my other patches.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

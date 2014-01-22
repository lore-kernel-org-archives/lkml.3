Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaAVJTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:19:03 -0500
Received: from mx0.aculab.com ([213.249.233.131]:53185 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754581AbaAVJS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:18:57 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'walt'" <w41ter@gmail.com>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
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
Thread-Index: AQHPELhlWPjDYPI+s0G+DC1zL1oFlJqEeIcAgABE3oCABEGkcIAB9dCAgAKL5bCAAHTLAIABApzggADQpQCAALrOYA==
Date: Wed, 22 Jan 2014 09:17:18 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D4637FB@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
 <20140120181442.GA5545@xanatos>
 <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
 <52DEEF88.8090709@gmail.com>
In-Reply-To: <52DEEF88.8090709@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0M9JDAl015457

From: walt
> On 01/21/2014 01:51 AM, David Laight wrote:
> > From: Sarah Sharp
> >> On Mon, Jan 20, 2014 at 11:21:14AM +0000, David Laight wrote:
> > ...
> >>> A guess...
> >>>
> >>> In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
> >>> of xhci_td_remainder().
> >>
> David, I tried the one-liner below, which changed nothing AFAICS, but
> then I'm not sure it's the change you intended:
...
>  		/* Set the TRB length, TD size, and interrupter fields. */
> -		if (xhci->hci_version < 0x100) {
> +		if (xhci->hci_version > 0x100) {
>  			remainder = xhci_td_remainder(
>  					urb->transfer_buffer_length -
>  					running_total);

So my wild guess wasn't right.
Can't win them all.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

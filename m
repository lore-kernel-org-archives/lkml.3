Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaAQOgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:36:25 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44380 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751965AbaAQOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:36:23 -0500
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
Thread-Index: AQHPELhlWPjDYPI+s0G+DC1zL1oFlJqEeIcAgABE3oCABEGkcA==
Date: Fri, 17 Jan 2014 14:34:07 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
In-Reply-To: <52D5ABBD.7090202@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0HEadHH025124

From: walt
> Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
> the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
> docking station, too.)
> 
> I can't believe the adapter works perfectly in a different computer.  Have you
> seen this kind of thing before?

Could be a horrid timing race between the cpu and xchi controller.
If the cpu manages to write a NOP or LINK TRB for a following transfer
before the controller polls the next entry (after raising the IRQ)
then the controller might process the LINK and then get confused
when it can't process the linked-to TRB.
This might not sound likely, but PCIe has significant latency.

> At the moment I have two machines using your xhci driver and both work perfectly,
> so I thank you again :)
> 
> I'm not sure where to go with this next.  I could put the adapter back in the
> other machine again if you have more patches to test.

Can you try the patch I posted that stops the ownership on LINK TRBs
being changed before that on the linked-to TRB?

I got a private mail from someone indicating that my earlier 'minimal'
patch helped an ASMedia controller talking to the asx189_178a ethernet
hardware.

	David


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

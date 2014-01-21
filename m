Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaAUJxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:53:04 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33877 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751613AbaAUJxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:53:00 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>
CC: "'walt'" <w41ter@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Thread-Index: AQHPELhlWPjDYPI+s0G+DC1zL1oFlJqEeIcAgABE3oCABEGkcIAB9dCAgAKL5bCAAHTLAIABApzg
Date: Tue, 21 Jan 2014 09:51:30 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D4609BF@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
 <20140120181442.GA5545@xanatos>
In-Reply-To: <20140120181442.GA5545@xanatos>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sarah Sharp
> On Mon, Jan 20, 2014 at 11:21:14AM +0000, David Laight wrote:
...
> > A guess...
> >
> > In queue_bulk_sg_tx() try calling xhci_v1_0_td_remainder() instead
> > of xhci_td_remainder().
> 
> Why?  Walt has a 0.96 xHCI host controller, and the format for how to
> calculate the TD remainder changed between the 0.96 and the 1.0 spec.
> That's why we have xhci_v1_0_td_remainder() and xhci_td_remainder().

I just wonder how many of those differences are just differences in the
specification, rather than differences in the hardware implementation.
In some cases it might be that the old hardware just ignored the value.

I know that the xhci hardware on my ivy bridge cpu does look at that
value (at least checking for zero), since things failed in subtle ways
when I got it wrong.

In this case it was just something easy to change that might be worth
trying.  I didn't necessarily expect it to make a positive difference.

	David




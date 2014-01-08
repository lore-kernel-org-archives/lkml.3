Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaAHR0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:26:31 -0500
Received: from mx0.aculab.com ([213.249.233.131]:36466 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756115AbaAHR01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:26:27 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Topic: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Thread-Index: AQHPDAsx5d97FnYUxUSD3GhphkgfRJp7CFoAgAABzdCAAAfrgIAAApgg
Date: Wed, 8 Jan 2014 17:24:42 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45567F@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D455602@AcuExch.aculab.com>
 <Pine.LNX.4.44L0.1401081210140.1659-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1401081210140.1659-100000@iolanthe.rowland.org>
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

> From: Alan Stern
> On Wed, 8 Jan 2014, David Laight wrote:
> 
> > > From: Alan Stern
> > >
> > > This may be a foolish question, but why is xhci-hcd using no-op TRBs in
> > > the first place?
> >
> > Because it can't write in a link TRB because other parts of the
> > code use link TRBs to detect the end of the ring.
> >
> > The problem is that it can't put a link TRB in the middle of
> > a chain of data fragments unless it is at a 'suitable' offset
> > from the start of the data TD. Given arbitrary input fragmentation
> > this means that you can't put a link TRB in the middle of a TD.
> > (The documented alignment might be as high as 16kB.)
> >
> > If the rest of the code used a 'ring end pointer' then a link TRB
> > could be used instead.
> 
> I see.  Sounds like a poor design decision in hindsight.  Can it be
> changed?

Anything can be changed :-)
But it is a bit pervasive.
Padding out with nops isolated the change.

	David




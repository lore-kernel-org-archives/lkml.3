Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaBDJcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:32:45 -0500
Received: from mx0.aculab.com ([213.249.233.131]:33297 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751484AbaBDJci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:32:38 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Markus Rechberger'" <mrechberger@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: RE: [BUGREPORT] Linux USB 3.0
Thread-Topic: [BUGREPORT] Linux USB 3.0
Thread-Index: AQHPITTBr91Kbmny9k2qZH16zHW8EJqk1Ejg
Date: Tue, 4 Feb 2014 09:31:52 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B8058@AcuExch.aculab.com>
References: <CA+O4pCJAL_Dqrt0mF5rbErBXbLTALx8Rrs1+vB3JmT=+rT0jCg@mail.gmail.com>
	<CA+O4pC+bHC1Bo4ERSfos8fL+FdnwXTTu_EE=rfd9eFkY7432Jg@mail.gmail.com>
	<CA+O4pCJ5xUQwRem3rvZbvv7K8BEnMW983Qq_vR0tVzwAwmVS6A@mail.gmail.com>
	<CA+O4pCJ9dFuwrcVF2b5MsreUb4NJX8t6664i3XHM9CYrdN7VzA@mail.gmail.com>
	<20140120193510.GC5545@xanatos>
 <CA+O4pC+inTZBSVJDBs4PfaDv0et3ZT+eN-1epThRJMztdgQryQ@mail.gmail.com>
In-Reply-To: <CA+O4pC+inTZBSVJDBs4PfaDv0et3ZT+eN-1epThRJMztdgQryQ@mail.gmail.com>
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

From: Markus Rechberger
> >> Dec 27 23:23:50 solist kernel: [   36.118245] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA
> ptr
> >
> > These messages might be harmless.  The 3.0 kernel contains a fix for
> > Intel Panther Point xHCI hosts that suppresses those messages, commit
> > ad808333d8201d53075a11bc8dd83b81f3d68f0b "Intel xhci: Ignore spurious
> > successful event."
> >
> > A later commit extends that to all xHCI 1.0 hosts, commit
> > 07f3cb7c28bf3f4dd80bfb136cf45810c46ac474 "usb: host: xhci: Enable
> > XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0"  That was
> > queued for 3.11 and marked to be backported into stable kernels as old
> > as 3.0.

I see the same error message on the 0.96 ASMedia controller when
the rx buffers for the ax88179_178a driver cross 64k boundaries.

So this isn't confined to 1.0 controllers.

	David




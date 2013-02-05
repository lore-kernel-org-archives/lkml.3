Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab3BEJGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:06:16 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:50498 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3BEJGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:06:11 -0500
X-Greylist: delayed 154529 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 04:06:11 EST
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Gleb Natapov <gleb@redhat.com>, Blue Swirl <blauwirbel@gmail.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
Thread-Topic: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
Thread-Index: AQHOAhg4taf68fRLz0WTtmu8HI0G/phoVPWAgAKVuwCAAA06UA==
Date: Tue, 5 Feb 2013 09:05:19 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C9014B42EE@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
 <CAAu8pHvk_2Mf2F-YTDC-wdyD1Jic-DHUanSQfOa3g0VchTcNig@mail.gmail.com>
 <20130205080436.GV23213@redhat.com>
In-Reply-To: <20130205080436.GV23213@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gleb Natapov [mailto:gleb@redhat.com]
> Sent: Tuesday, February 05, 2013 12:05 AM
> To: Blue Swirl
> Cc: Pandarathil, Vijaymohan R; Alex Williamson; Bjorn Helgaas; Ortiz, Lance
> E; kvm@vger.kernel.org; qemu-devel@nongnu.org; linux-pci@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for VFIO-
> PCI devices
> 
> On Sun, Feb 03, 2013 at 04:36:11PM +0000, Blue Swirl wrote:
> > On Sun, Feb 3, 2013 at 2:10 PM, Pandarathil, Vijaymohan R
> > <vijaymohan.pandarathil@hp.com> wrote:
> > >         - Create eventfd per vfio device assigned to a guest and
> register an
> > >           event handler
> > >
> > >         - This fd is passed to the vfio_pci driver through the SET_IRQ
> ioctl
> > >
> > >         - When the device encounters an error, the eventfd is signalled
> > >           and the qemu eventfd handler gets invoked.
> > >
> > >         - In the handler decide what action to take. Current action
> taken
> > >           is to terminate the guest.
> >
> > Usually this is not OK, but I guess this is not guest triggerable.
> >
> Still not OK. Why not stop a guest with appropriate stop reason?

The thinking was that since this is a hardware error, we would want to stop the guest at the earliest. The hw_error() routine which aborts the qemu process was suggested by Alex and that seemed appropriate. Earlier I was using qemu_system_shutdown_request().  Any suggestions ?

Thanks

Vijay
> 
> --
> 			Gleb.

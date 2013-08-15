Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3HOKPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:15:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52776 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab3HOKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:14:58 -0400
Date: Thu, 15 Aug 2013 12:14:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
Message-ID: <20130815101455.GA25528@amd.pavel.ucw.cz>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
 <20130813124311.GA18426@amd.pavel.ucw.cz>
 <1376511850.113256.29.camel@blbiskey-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376511850.113256.29.camel@blbiskey-desk1.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Since it is a PCIe card, it does not have the ability to host hardware
> > > devices for networking, storage and console. We provide these devices
> > > on X100 coprocessors thus enabling a self-bootable equivalent environment
> > > for applications. A key benefit of our solution is that it leverages
> > > the standard virtio framework for network, disk and console devices,
> > > though in our case the virtio framework is used across a PCIe bus.
> > 
> > Interesting...
> > 
> > >  Documentation/mic/mic_overview.txt   |   48 +
> > >  Documentation/mic/mpssd/.gitignore   |    1 +
> > >  Documentation/mic/mpssd/Makefile     |   20 +
> > >  Documentation/mic/mpssd/micctrl      |  157 +++
> > >  Documentation/mic/mpssd/mpss         |  246 +++++
> > >  Documentation/mic/mpssd/mpssd.c      | 1732 ++++++++++++++++++++++++++++++++++
> > >  Documentation/mic/mpssd/mpssd.h      |  105 +++
> > >  Documentation/mic/mpssd/sysfs.c      |  108 +++
> > >  drivers/misc/Kconfig                 |    1 +
> > >  drivers/misc/Makefile                |    1 +
> > >  drivers/misc/mic/Kconfig             |   56 ++
> > >  drivers/misc/mic/Makefile            |    6 +
> > >  drivers/misc/mic/card/Makefile       |   11 +
> > >  drivers/misc/mic/card/mic_common.h   |   43 +
> > >  drivers/misc/mic/card/mic_debugfs.c  |  139 +++
> > >  drivers/misc/mic/card/mic_debugfs.h  |   40 +
> > >  drivers/misc/mic/card/mic_device.c   |  311 ++++++
> > >  drivers/misc/mic/card/mic_device.h   |  106 +++
> > >  drivers/misc/mic/card/mic_virtio.c   |  643 +++++++++++++
> > >  drivers/misc/mic/card/mic_virtio.h   |   79 ++
> > >  drivers/misc/mic/card/mic_x100.c     |  253 +++++
> > >  drivers/misc/mic/card/mic_x100.h     |   53 ++
> > >  drivers/misc/mic/common/mic_device.h |   85 ++
> > >  drivers/misc/mic/host/Makefile       |   13 +
> > >  drivers/misc/mic/host/mic_boot.c     |  181 ++++
> > 
> > So... there are basically separate computers running on PCIe card
> > plugged into host computer, right?
> > 
> 
> They are PCIe form factor Coprocessors plugged into the host.
> 
> > Maybe we should have something more promintent than drivers/misc for
> > this, then? Like drivers/multicomputer?
> > 
> 
> multicomputer" is an interesting name for these kind of devices but has
> several issues:
> a) The definition I found for multicomputer online was "A computer made
> up of several computers. The term generally refers to an architecture in
> which each processor has its own memory rather than multiple processors
> with a shared memory. A multicore computer, although it sounds similar,
> would not be a multicomputer because the multiple cores share a common
> memory." Intel MIC X100 devices typically have upto 244 CPUs (61 cores)
> on the card sharing common card memory so multicomputer would not be
> accurate based on this definition.

Well... you have your "host" computer, and than (potentially several)
Intel MIC devices, which are basically separate computers. So X100 is
not a multicomputer, but machine with several X100 cards certainly is
multicomputer.

> b) X100 MIC devices have always been referred to Coprocessors and never
> as multicomputers in product specifications @
> http://software.intel.com/en-us/mic-developer

Coprocessor sounds like i487, but why not.

> c) multicomputer is a very long path name.

Agreed it is long. drivers/coproc? 

[I guess we'll get similar hardware from different vendors in
future. It would make sense having it at common place.]

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

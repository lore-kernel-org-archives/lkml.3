Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab3HNU2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:28:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:37482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab3HNU2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:28:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,879,1367996400"; 
   d="scan'208";a="346459937"
Subject: Re: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Pavel Machek <pavel@ucw.cz>
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
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20130813124311.GA18426@amd.pavel.ucw.cz>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <20130813124311.GA18426@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Aug 2013 13:24:10 -0700
Message-ID: <1376511850.113256.29.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 14:43 +0200, Pavel Machek wrote:
> Hi!
> 
> > Since it is a PCIe card, it does not have the ability to host hardware
> > devices for networking, storage and console. We provide these devices
> > on X100 coprocessors thus enabling a self-bootable equivalent environment
> > for applications. A key benefit of our solution is that it leverages
> > the standard virtio framework for network, disk and console devices,
> > though in our case the virtio framework is used across a PCIe bus.
> 
> Interesting...
> 
> >  Documentation/mic/mic_overview.txt   |   48 +
> >  Documentation/mic/mpssd/.gitignore   |    1 +
> >  Documentation/mic/mpssd/Makefile     |   20 +
> >  Documentation/mic/mpssd/micctrl      |  157 +++
> >  Documentation/mic/mpssd/mpss         |  246 +++++
> >  Documentation/mic/mpssd/mpssd.c      | 1732 ++++++++++++++++++++++++++++++++++
> >  Documentation/mic/mpssd/mpssd.h      |  105 +++
> >  Documentation/mic/mpssd/sysfs.c      |  108 +++
> >  drivers/misc/Kconfig                 |    1 +
> >  drivers/misc/Makefile                |    1 +
> >  drivers/misc/mic/Kconfig             |   56 ++
> >  drivers/misc/mic/Makefile            |    6 +
> >  drivers/misc/mic/card/Makefile       |   11 +
> >  drivers/misc/mic/card/mic_common.h   |   43 +
> >  drivers/misc/mic/card/mic_debugfs.c  |  139 +++
> >  drivers/misc/mic/card/mic_debugfs.h  |   40 +
> >  drivers/misc/mic/card/mic_device.c   |  311 ++++++
> >  drivers/misc/mic/card/mic_device.h   |  106 +++
> >  drivers/misc/mic/card/mic_virtio.c   |  643 +++++++++++++
> >  drivers/misc/mic/card/mic_virtio.h   |   79 ++
> >  drivers/misc/mic/card/mic_x100.c     |  253 +++++
> >  drivers/misc/mic/card/mic_x100.h     |   53 ++
> >  drivers/misc/mic/common/mic_device.h |   85 ++
> >  drivers/misc/mic/host/Makefile       |   13 +
> >  drivers/misc/mic/host/mic_boot.c     |  181 ++++
> 
> So... there are basically separate computers running on PCIe card
> plugged into host computer, right?
> 

They are PCIe form factor Coprocessors plugged into the host.

> Maybe we should have something more promintent than drivers/misc for
> this, then? Like drivers/multicomputer?
> 

multicomputer" is an interesting name for these kind of devices but has
several issues:
a) The definition I found for multicomputer online was "A computer made
up of several computers. The term generally refers to an architecture in
which each processor has its own memory rather than multiple processors
with a shared memory. A multicore computer, although it sounds similar,
would not be a multicomputer because the multiple cores share a common
memory." Intel MIC X100 devices typically have upto 244 CPUs (61 cores)
on the card sharing common card memory so multicomputer would not be
accurate based on this definition.
b) X100 MIC devices have always been referred to Coprocessors and never
as multicomputers in product specifications @
http://software.intel.com/en-us/mic-developer
c) multicomputer is a very long path name.

Given these issues, we would like to stick to drivers/misc/mic/ unless
you have objections to this approach.

Thanks for the feedback.
Sudeep Dutt

> 									Pavel
> 



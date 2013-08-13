Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3HMMnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:43:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60670 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab3HMMnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:43:12 -0400
Date: Tue, 13 Aug 2013 14:43:11 +0200
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
Message-ID: <20130813124311.GA18426@amd.pavel.ucw.cz>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1374717252.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Since it is a PCIe card, it does not have the ability to host hardware
> devices for networking, storage and console. We provide these devices
> on X100 coprocessors thus enabling a self-bootable equivalent environment
> for applications. A key benefit of our solution is that it leverages
> the standard virtio framework for network, disk and console devices,
> though in our case the virtio framework is used across a PCIe bus.

Interesting...

>  Documentation/mic/mic_overview.txt   |   48 +
>  Documentation/mic/mpssd/.gitignore   |    1 +
>  Documentation/mic/mpssd/Makefile     |   20 +
>  Documentation/mic/mpssd/micctrl      |  157 +++
>  Documentation/mic/mpssd/mpss         |  246 +++++
>  Documentation/mic/mpssd/mpssd.c      | 1732 ++++++++++++++++++++++++++++++++++
>  Documentation/mic/mpssd/mpssd.h      |  105 +++
>  Documentation/mic/mpssd/sysfs.c      |  108 +++
>  drivers/misc/Kconfig                 |    1 +
>  drivers/misc/Makefile                |    1 +
>  drivers/misc/mic/Kconfig             |   56 ++
>  drivers/misc/mic/Makefile            |    6 +
>  drivers/misc/mic/card/Makefile       |   11 +
>  drivers/misc/mic/card/mic_common.h   |   43 +
>  drivers/misc/mic/card/mic_debugfs.c  |  139 +++
>  drivers/misc/mic/card/mic_debugfs.h  |   40 +
>  drivers/misc/mic/card/mic_device.c   |  311 ++++++
>  drivers/misc/mic/card/mic_device.h   |  106 +++
>  drivers/misc/mic/card/mic_virtio.c   |  643 +++++++++++++
>  drivers/misc/mic/card/mic_virtio.h   |   79 ++
>  drivers/misc/mic/card/mic_x100.c     |  253 +++++
>  drivers/misc/mic/card/mic_x100.h     |   53 ++
>  drivers/misc/mic/common/mic_device.h |   85 ++
>  drivers/misc/mic/host/Makefile       |   13 +
>  drivers/misc/mic/host/mic_boot.c     |  181 ++++

So... there are basically separate computers running on PCIe card
plugged into host computer, right?

Maybe we should have something more promintent than drivers/misc for
this, then? Like drivers/multicomputer?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

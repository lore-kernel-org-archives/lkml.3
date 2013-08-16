Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab3HPRIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:08:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:45681 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab3HPRIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,895,1367996400"; 
   d="scan'208";a="388319973"
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: "Dutt, Sudeep" <sudeep.dutt@intel.com>
CC: Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        "Dixit, Ashutosh" <ashutosh.dixit@intel.com>,
        "Yokoyama, Caz" <caz.yokoyama@intel.com>,
        "Chandramouli, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        "Kharche, Harshavardhan R" <harshavardhan.r.kharche@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>
Subject: Re: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
Thread-Topic: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
Thread-Index: AQHOiOgP0vy5+TRfgkmHFXAAjFbxV5mTqN+AgAITIQCAAOgbgIACA16AgAACZ4A=
Date: Fri, 16 Aug 2013 17:08:13 +0000
Message-ID: <1376672885.5327.4.camel@ppwaskie-mobl2>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <20130813124311.GA18426@amd.pavel.ucw.cz>
	 <1376511850.113256.29.camel@blbiskey-desk1.amr.corp.intel.com>
	 <20130815101455.GA25528@amd.pavel.ucw.cz>
	 <1376672369.93110.13.camel@blbiskey-desk1.amr.corp.intel.com>
In-Reply-To: <1376672369.93110.13.camel@blbiskey-desk1.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.14.94]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A825E9D3637B1B4D8785E82B7D5AFEC5@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7GH8Ts6024201

On Fri, 2013-08-16 at 09:59 -0700, Sudeep Dutt wrote:
> On Thu, 2013-08-15 at 12:14 +0200, Pavel Machek wrote:
> > Hi!
> > 
> 
> Hi!
> 
> > > > > Since it is a PCIe card, it does not have the ability to host hardware
> > > > > devices for networking, storage and console. We provide these devices
> > > > > on X100 coprocessors thus enabling a self-bootable equivalent environment
> > > > > for applications. A key benefit of our solution is that it leverages
> > > > > the standard virtio framework for network, disk and console devices,
> > > > > though in our case the virtio framework is used across a PCIe bus.
> > > > 
> > > > Interesting...
> > > > 
> > > > >  Documentation/mic/mic_overview.txt   |   48 +
> > > > >  Documentation/mic/mpssd/.gitignore   |    1 +
> > > > >  Documentation/mic/mpssd/Makefile     |   20 +
> > > > >  Documentation/mic/mpssd/micctrl      |  157 +++
> > > > >  Documentation/mic/mpssd/mpss         |  246 +++++
> > > > >  Documentation/mic/mpssd/mpssd.c      | 1732 ++++++++++++++++++++++++++++++++++
> > > > >  Documentation/mic/mpssd/mpssd.h      |  105 +++
> > > > >  Documentation/mic/mpssd/sysfs.c      |  108 +++
> > > > >  drivers/misc/Kconfig                 |    1 +
> > > > >  drivers/misc/Makefile                |    1 +
> > > > >  drivers/misc/mic/Kconfig             |   56 ++
> > > > >  drivers/misc/mic/Makefile            |    6 +
> > > > >  drivers/misc/mic/card/Makefile       |   11 +
> > > > >  drivers/misc/mic/card/mic_common.h   |   43 +
> > > > >  drivers/misc/mic/card/mic_debugfs.c  |  139 +++
> > > > >  drivers/misc/mic/card/mic_debugfs.h  |   40 +
> > > > >  drivers/misc/mic/card/mic_device.c   |  311 ++++++
> > > > >  drivers/misc/mic/card/mic_device.h   |  106 +++
> > > > >  drivers/misc/mic/card/mic_virtio.c   |  643 +++++++++++++
> > > > >  drivers/misc/mic/card/mic_virtio.h   |   79 ++
> > > > >  drivers/misc/mic/card/mic_x100.c     |  253 +++++
> > > > >  drivers/misc/mic/card/mic_x100.h     |   53 ++
> > > > >  drivers/misc/mic/common/mic_device.h |   85 ++
> > > > >  drivers/misc/mic/host/Makefile       |   13 +
> > > > >  drivers/misc/mic/host/mic_boot.c     |  181 ++++
> > > > 
> > > > So... there are basically separate computers running on PCIe card
> > > > plugged into host computer, right?
> > > > 
> > > 
> > > They are PCIe form factor Coprocessors plugged into the host.
> > > 
> > > > Maybe we should have something more promintent than drivers/misc for
> > > > this, then? Like drivers/multicomputer?
> > > > 
> > > 
> > > multicomputer" is an interesting name for these kind of devices but has
> > > several issues:
> > > a) The definition I found for multicomputer online was "A computer made
> > > up of several computers. The term generally refers to an architecture in
> > > which each processor has its own memory rather than multiple processors
> > > with a shared memory. A multicore computer, although it sounds similar,
> > > would not be a multicomputer because the multiple cores share a common
> > > memory." Intel MIC X100 devices typically have upto 244 CPUs (61 cores)
> > > on the card sharing common card memory so multicomputer would not be
> > > accurate based on this definition.
> > 
> > Well... you have your "host" computer, and than (potentially several)
> > Intel MIC devices, which are basically separate computers. So X100 is
> > not a multicomputer, but machine with several X100 cards certainly is
> > multicomputer.
> > 
> > > b) X100 MIC devices have always been referred to Coprocessors and never
> > > as multicomputers in product specifications @
> > > http://software.intel.com/en-us/mic-developer
> > 
> > Coprocessor sounds like i487, but why not.
> > 
> > > c) multicomputer is a very long path name.
> > 
> > Agreed it is long. drivers/coproc? 
> > 
> > [I guess we'll get similar hardware from different vendors in
> > future. It would make sense having it at common place.]
> > 
> 
> drivers/coproc is a good, short suggestion. Intel MIC X100 devices are
> likely unique since they can run a general purpose OS in a PCIe form
> factor Coprocessor plugged to the host. This might result in MIC
> potentially being the only driver under drivers/coproc till another
> general purpose Coprocessor comes along. Is it recommended to create a
> new driver directory (drivers/coproc) in anticipation of future devices?
> Do you think it would be better if we revive this discussion, once
> another Coprocessor with similar capabilities comes along?

Creating a new driver directory for one device that may never have a
similar device to share that directory seems a bit overkill.  git mv is
simple and quick to rearrange the directory structure later if the need
arises (with the appropriate Kconfig tweakage).

-PJ
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

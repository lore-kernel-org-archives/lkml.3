Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3HBAil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:38:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:9857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab3HBAij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:38:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,797,1367996400"; 
   d="scan'208";a="340416799"
Subject: Re: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
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
In-Reply-To: <20130801014608.GD6941@kroah.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
	 <20130801014608.GD6941@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Aug 2013 17:34:44 -0700
Message-ID: <1375403684.61060.66.camel@blbiskey-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 18:46 -0700, Greg Kroah-Hartman wrote: 
> On Wed, Jul 24, 2013 at 08:31:31PM -0700, Sudeep Dutt wrote:
> > An Intel MIC X100 device is a PCIe form factor add-in coprocessor
> > card based on the Intel Many Integrated Core (MIC) architecture
> > that runs a Linux OS. It is a PCIe endpoint in a platform and therefore
> > implements the three required standard address spaces i.e. configuration,
> > memory and I/O. The host OS loads a device driver as is typical for
> > PCIe devices. The card itself runs a bootstrap after reset that
> > transfers control to the card OS downloaded from the host driver.
> > The card OS as shipped by Intel is a Linux kernel with modifications
> > for the X100 devices.
> > 
> > Since it is a PCIe card, it does not have the ability to host hardware
> > devices for networking, storage and console. We provide these devices
> > on X100 coprocessors thus enabling a self-bootable equivalent environment
> > for applications. A key benefit of our solution is that it leverages
> > the standard virtio framework for network, disk and console devices,
> > though in our case the virtio framework is used across a PCIe bus.
> > 
> > Here is a block diagram of the various components described above. The
> > virtio backends are situated on the host rather than the card given better
> > single threaded performance for the host compared to MIC and the ability of
> > the host to initiate DMA's to/from the card using the MIC DMA engine.
> > 
> >                               |
> >        +----------+           |             +----------+
> >        | Card OS  |           |             | Host OS  |
> >        +----------+           |             +----------+
> >                               |
> > +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
> > | Virtio| |Virtio  | |Virtio| | |Virtio   |  |Virtio  | |Virtio  |
> > | Net   | |Console | |Block | | |Net      |  |Console | |Block   |
> > | Driver| |Driver  | |Driver| | |backend  |  |backend | |backend |
> > +-------+ +--------+ +------+ | +---------+  +--------+ +--------+
> >     |         |         |     |      |            |         |
> >     |         |         |     |Ring 3|            |         |
> >     |         |         |     |------|------------|---------|-------
> >     +-------------------+     |Ring 0+--------------------------+
> >               |               |      | Virtio over PCIe IOCTLs  |
> >               |               |      +--------------------------+
> >       +--------------+        |                   |
> >       |Intel MIC     |        |            +---------------+
> >       |Card Driver   |        |            |Intel MIC      |
> >       +--------------+        |            |Host Driver    |
> >               |               |            +---------------+
> >               |               |                   |
> >      +-------------------------------------------------------------+
> >      |                                                             |
> >      |                    PCIe Bus                                 |
> >      +-------------------------------------------------------------+
> 
> That's some nice information, why isn't it in one of the patches you
> sent, so that others can read it later on to try to figure out what is
> going on with this codebase?
> 

The description in the cover letter is also provided in PATCH 5 of the
series @ Documentation/mic/mic_overview.txt [1].
Thanks,
Sudeep Dutt

[1] https://lkml.org/lkml/2013/7/24/812

> thanks,
> 
> greg k-h






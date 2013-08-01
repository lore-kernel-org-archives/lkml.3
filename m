Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3HAHp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:45:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3HAHp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:45:26 -0400
Date: Thu, 1 Aug 2013 15:45:09 +0800
From: Asias He <asias@redhat.com>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Rob Landley <rob@landley.net>, Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>
Subject: Re: [PATCH 0/5] Enable Drivers for Intel MIC X100 Coprocessors.
Message-ID: <20130801074509.GA27797@hj.localdomain>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
 <20130801014608.GD6941@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801014608.GD6941@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sudeep Dutt,

On Wed, Jul 31, 2013 at 06:46:08PM -0700, Greg Kroah-Hartman wrote:
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


Could you send the whole series to virtualization@lists.linux-foundation.org next time?


> That's some nice information, why isn't it in one of the patches you
> sent, so that others can read it later on to try to figure out what is
> going on with this codebase?
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

-- 
Asias

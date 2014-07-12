Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaGLGuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 02:50:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:40960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaGLGuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 02:50:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,648,1400050800"; 
   d="scan'208";a="542337243"
Subject: Re: [PATCH char-misc-next v3 2/8] misc: mic: add a bus driver for
 virtual MIC devices
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Sudeep Dutt <sudeep.dutt@intel.com>
In-Reply-To: <20140712013136.GA17540@kroah.com>
References: <cover.1405109401.git.sudeep.dutt@intel.com>
	 <9f7cf168a23057b5a1a251f79e004bd449f9cb59.1405109402.git.sudeep.dutt@intel.com>
	 <20140712012720.GA31863@kroah.com>  <20140712013136.GA17540@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jul 2014 23:49:56 -0700
Message-ID: <1405147796.44464.70.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 18:31 -0700, Greg Kroah-Hartman wrote:
> On Fri, Jul 11, 2014 at 06:27:20PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, Jul 11, 2014 at 02:04:20PM -0700, Sudeep Dutt wrote:
> > > This MIC virtual bus driver takes the responsibility of creating all
> > > the virtual devices connected to the PCIe device on the host and the
> > > platform device on the card. The MIC bus hardware operations provide
> > > a way to abstract certain hardware details from the base physical devices.
> > > Examples of devices added on the MIC virtual bus include host DMA and card DMA.
> > > This abstraction enables using a common DMA driver on host and card.
> > > 
> > > Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> > > Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> > > Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
> > > Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
> > > ---
> > >  drivers/misc/mic/Kconfig       |  17 ++++
> > >  drivers/misc/mic/Makefile      |   1 +
> > >  drivers/misc/mic/bus/Makefile  |   5 +
> > >  drivers/misc/mic/bus/mic_bus.c | 218 +++++++++++++++++++++++++++++++++++++++++
> > >  include/linux/mic_bus.h        | 110 +++++++++++++++++++++
> > >  5 files changed, 351 insertions(+)
> > >  create mode 100644 drivers/misc/mic/bus/Makefile
> > >  create mode 100644 drivers/misc/mic/bus/mic_bus.c
> > >  create mode 100644 include/linux/mic_bus.h
> > 
> > Looks good, but no addition to scripts/mod/file2alias.c to allow
> > autoloading of mic_bus drivers?
> > 
> > I'll take patches 1 and 2 here, as I need some acks from the DMA people
> > on patch 3.
> 
> And I took 4-8 as well, as they seemed independant from patch 3.
> 

Thanks for accepting the patches Greg. The good news is that the 7
patches accepted build fine without patch 3 and the drivers load
successfully.

The bad news is that the MIC Coprocessors no longer boot without patch 3
since the host driver does not find any DMA channels. Reverting patch 5
titled "add dma support in host driver" with SHA d4ef098 allows the
Coprocessors to boot again but accepting patch 3 instead is the cleanest
solution here. Dan, please review patch 3 as we would really like it to
get accepted before the 3.17 merge window opens.

Thanks,
Sudeep Dutt


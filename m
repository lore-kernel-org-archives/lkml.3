Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3G2KZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:25:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:27864 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab3G2KZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,768,1367996400"; 
   d="scan'208";a="377717627"
Date: Mon, 29 Jul 2013 15:15:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Matt Porter <matt@ohporter.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] dma: edma: add device_slave_caps() support
Message-ID: <20130729094557.GG29095@intel.com>
References: <1374597804-3961-1-git-send-email-joelf@ti.com>
 <51EF8A52.90902@metafoo.de>
 <51EF8C2B.2030409@ti.com>
 <51EF8F4E.8080806@metafoo.de>
 <FB20353E-4890-4462-A671-3587A3841B4A@ti.com>
 <51EF92F2.3030405@metafoo.de>
 <51F0231C.7000401@ti.com>
 <20130724183329.GH18642@intel.com>
 <51F02CBA.5060704@ti.com>
 <20130725072351.GJ18642@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725072351.GJ18642@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:53:51PM +0530, Vinod Koul wrote:
> On Wed, Jul 24, 2013 at 02:36:26PM -0500, Joel Fernandes wrote:
> > > Also another point worth considering is the approach Russell suggested, I havent
> > > gotten a chance to dig deeper but if I understood it correctly then programming
> > > the device_dma_parameters should be the right thing to do. Again I need to look
> > > deeper and esp wrt edma
> > 
> > OK. I have some patches sitting in my tree too that I'm working on. With
> > that I don't need to know about maximum number of allowed segments and
> > can send along any number of segment. I will rework them and post them.
> > fwiw, I will also implement caps API incase like Lars did populating the
> > other fields though these will not be unused.
> > 
> > For segment size, at this time I don't know any driver that uses it
> > other than davinci-pcm. For this reason the calculations can be done as
> > Lars suggested (for minimum of maximum). Do you know in advance if
> > you're going to amend to drop segment size if we go with what Russell
> > suggested, or are you going to leave the seg-size in the caps API anyway.
> I am just back and havent really done my work on this. Let me check and as I
> said if my understanding is right I would be inclined to remove these fields...
Okay so the max sg_len should be done by setting the device_dma_parameters.

See the example in MXS DMA and MMC drivers

Now for second parameter why do you need that to be passed, I thought in edma the
clients needs this value somehow to program the channel. It would be good that
if we can delink from this and let edma derive. Also there should be no such
thing as max_sg, the driver should be able to perform any size of sg_list.
Internally it can be breaking the dma into multiple trasnactions.

~Vinod
-- 

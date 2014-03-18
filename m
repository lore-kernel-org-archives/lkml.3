Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaCRPif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:38:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaCRPid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:38:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Sandeep Nair <sandeep_n@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, dmaengine@vger.kernel.org
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
Date: Tue, 18 Mar 2014 16:38:25 +0100
Message-ID: <4424649.TIey3uEAed@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140318152444.GC1976@intel.com>
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com> <53274F0B.5070201@ti.com> <20140318152444.GC1976@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S4etyBSatsDP4tmc5/MEyOjpR5GI4Lk6y5Cft8E11kn
 xv7vYx95cNs9DRutIOBN2CpkI3EbxPo4ACNLvfj6lexVKGaIgJ
 1fFU1HRY9GyXnGXKmgwuglBvknfrXyBRoYO6f9pRIYIOVttFVI
 aG8dkZJeUbLfR4ww5X+jeP74xg+bHEKy3z9OmWEYn2eyh9HErm
 RiUhI6GI17IjK1iLIyyLfJTGas9btY69lDJZNBdvSoMzAgBrTj
 QH+cQSgTrfbFOBHIslSLh78cc7tbP51XJkw9o6LYC2z0SoWnTe
 /7KiJZGtcEf/Y66CfTWoqnac9M5/tzp1vTBOtTPRAWViCmFRjx
 NiNQrloJQLu7x0p4GqFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2014 20:54:44 Vinod Koul wrote:
> On Mon, Mar 17, 2014 at 03:37:47PM -0400, Santosh Shilimkar wrote:
> > >> To simplify this bit more, you can think of this as DMA channels, flows
> > >> are allocated and DMA channels are enabled by DMA engine and they remains
> > >> enabled always as long as the channel in use. Enablling dma channel
> > >> actually don't start the DMA transfer but just sets up the connection/pipe
> > >> with peripheral and memory and vice a versa.
> > >>
> > >> All the descriptor management, triggering, sending completion interrupt or
> > >> hardware signal to DMAEngine all managed by centralised QMSS.
> > >>
> > >> Actual copy of data is still done by DMA hardware but its completely
> > >> transparent to software. DMAEngine hardware takes care of that in the
> > >> backyard.
> > > So you will use the dmaengine just for setting up the controller. Not for actual
> > > transfers. Those would be governed by the QMSS, right?
> > >
> > Correct.
> >  
> > > This means that someone expecting to use dmaengine API will get confused about
> > > this and doing part (alloc) thru dmaengine and rest (transfers) using some other
> > > API. This brings to me the design approach, does it really make sense creating
> > > dmaengine driver for this when we are not fully complying to the API
> > > 
> > Thats fair. The rationale behind usage of DMEngine was that its the closest
> > available subsystem which can be leveraged for this hardware. We can
> > pretty much use all the standard DMAEngine device tree parsing as well as
> > the config API to setup DMAs. 
> > 
> > I think you made your stand clear, just to confirm, you don't prefer this
> > driver to be a DMAEngine driver considering it doesn't fully complying to
> > the APIs. We could document the deviation of 'transfer' handling to avoid
> > any confusion.
> Yup, a user will just get confused as the driver doenst conform the dmaengine
> API. Unless someone comes up witha  strong argument on why it should be
> dmaengine driver and what befits we see form such a model, i would like a
> damengine driver to comply to standard API and usage.

I think it would be possible to turn the QMSS driver into a library and have
the packet DMA code use the proper dmaengine API by calling into that code.

The main user of packet DMA (the ethernet driver) would however still have
to call into QMSS directly, so I'm not sure if it's worth the effort.

	Arnd

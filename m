Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaCRQlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:41:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:62773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaCRQlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:41:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] dma: Add Keystone Packet DMA Engine driver
Date: Tue, 18 Mar 2014 17:40:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Vinod Koul <vinod.koul@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Sandeep Nair <sandeep_n@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, dmaengine@vger.kernel.org
References: <1393628200-12317-1-git-send-email-santosh.shilimkar@ti.com> <4424649.TIey3uEAed@wuerfel> <532872AD.2090804@ti.com>
In-Reply-To: <532872AD.2090804@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403181740.11693.arnd@arndb.de>
X-Provags-ID: V02:K0:edfWHQXGHOu9Nngv3+IPz0b1WW5Fmyo3d1xzrP1B9a0
 lmG5hqkobMswCZtOcD7U+09IsPG0bPVm8AhJDWuFCa+i8t7sP7
 7bDV+ENLOoetZwKKre/nlQ2fLRd3l7z/NOvEz9joCjjgwTU8tA
 xWDTmFfz1EZY6IlKcid2UbuVqT5OhzLY5Y558/x2If/AdGi0Hk
 Du/wAoQ678oGpRvnGqxWUUZkz9p/Y9xqoekIRZrRQG0ZRbTqU3
 4lQvvBmG3ut8IwP+QS+1HrE0qtEZGHZlpL/3YpJx7K1WecSDs7
 pWirZSqjJXz0I6p+plQ921O+Z2rSgz/OExo72ydGKttLn8LCKr
 SWM8cwj8xgRHVmKDOBemjL8TiSYdOg6TAomP9t7jT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2014, Santosh Shilimkar wrote:
> 
> On Tuesday 18 March 2014 11:38 AM, Arnd Bergmann wrote:
> > On Tuesday 18 March 2014 20:54:44 Vinod Koul wrote:
> >> On Mon, Mar 17, 2014 at 03:37:47PM -0400, Santosh Shilimkar wrote:
> >>>>> To simplify this bit more, you can think of this as DMA channels, flows
> >>>>> are allocated and DMA channels are enabled by DMA engine and they remains
> >>>>> enabled always as long as the channel in use. Enablling dma channel
> >>>>> actually don't start the DMA transfer but just sets up the connection/pipe
> >>>>> with peripheral and memory and vice a versa.
> >>>>>
> >>>>> All the descriptor management, triggering, sending completion interrupt or
> >>>>> hardware signal to DMAEngine all managed by centralised QMSS.
> >>>>>
> >>>>> Actual copy of data is still done by DMA hardware but its completely
> >>>>> transparent to software. DMAEngine hardware takes care of that in the
> >>>>> backyard.
> >>>> So you will use the dmaengine just for setting up the controller. Not for actual
> >>>> transfers. Those would be governed by the QMSS, right?
> >>>>
> >>> Correct.
> >>>  
> >>>> This means that someone expecting to use dmaengine API will get confused about
> >>>> this and doing part (alloc) thru dmaengine and rest (transfers) using some other
> >>>> API. This brings to me the design approach, does it really make sense creating
> >>>> dmaengine driver for this when we are not fully complying to the API
> >>>>
> >>> Thats fair. The rationale behind usage of DMEngine was that its the closest
> >>> available subsystem which can be leveraged for this hardware. We can
> >>> pretty much use all the standard DMAEngine device tree parsing as well as
> >>> the config API to setup DMAs. 
> >>>
> >>> I think you made your stand clear, just to confirm, you don't prefer this
> >>> driver to be a DMAEngine driver considering it doesn't fully complying to
> >>> the APIs. We could document the deviation of 'transfer' handling to avoid
> >>> any confusion.
> >> Yup, a user will just get confused as the driver doenst conform the dmaengine
> >> API. Unless someone comes up witha  strong argument on why it should be
> >> dmaengine driver and what befits we see form such a model, i would like a
> >> damengine driver to comply to standard API and usage.
> > 
> > I think it would be possible to turn the QMSS driver into a library and have
> > the packet DMA code use the proper dmaengine API by calling into that code.
> > 
> > The main user of packet DMA (the ethernet driver) would however still have
> > to call into QMSS directly, so I'm not sure if it's worth the effort.
> > 
> Its not. Am going to move this driver along with QMSS which is one
> of the options we discussed.

Ok, fair enough. Looking forward to the patches.

	Arnd

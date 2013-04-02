Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041Ab3DBIOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:14:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40714 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3DBIOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:14:31 -0400
Message-ID: <515A9352.5060702@ti.com>
Date: Tue, 2 Apr 2013 10:14:10 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [RFC] dmaengine: omap-dma: Start DMA without delay
References: <1364566323-24144-1-git-send-email-peter.ujfalusi@ti.com> <20130329173100.GV30923@n2100.arm.linux.org.uk>
In-Reply-To: <20130329173100.GV30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 03/29/2013 06:31 PM, Russell King - ARM Linux wrote:
> On Fri, Mar 29, 2013 at 03:12:03PM +0100, Peter Ujfalusi wrote:
>> Remove the use of a tasklet to start the DMA channel when issue_pending is
>> called.
>> The use of tasklet delays the DMA start which can cause issues at drivers,
>> for example the audio drivers expect that the DMA is started right away.
>>
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>> ---
>> Hi Russell,
>>
>> I know you are against removing the tasklet since you have planed to move the
>> omap-dma to use runtime/dynamic DMA channel use.
>> I have looked at the amba-pl08x.c driver which is doing that exactly (as you
>> pointed out that to me). AMBA did not use tasklet either and I'm sure we can
>> change the omap-dma driver to do the same in a same way as we could have done it
>> with the tasklet use.
> 
> It's rather sad that you're ignoring what I'm saying, and going by what
> another DMA engine driver - which is self contained - is doing, rather
> than listening to my arguments against that approach.

The reason I send this as RFC to start a discussion to find out how we should
handle this. I were to ignore what you were saying I would have just sent a
PATCH instead.

I don't think that the tasklet is the solution for the runtime DMA channel
selection. We can do it in a same way as AMBA has been doing. In this way we
can handle all cases with the same code.
The pre-allocating of channels and starting the DMA right away is different issue.

What need to be done anyway is to convert the remaining drivers to use dmaengine:
drivers/usb/musb/tusb6010_omap.c
drivers/usb/gadget/omap_udc.c
drivers/mtd/onenand/omap2.c
drivers/media/platform/omap3isp/isphist.c
drivers/media/platform/soc_camera/omap1_camera.c
drivers/media/platform/omap/omap_vout_vrfb.c

When that is done we can remove the arch/arm/plat-omap/dma.c and migrate the
code under dmaengine to restructure it and finally we can have runtime channel
allocation.

-- 
Péter

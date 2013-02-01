Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab3BAIxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:53:42 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47053 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3BAIxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:53:30 -0500
MIME-Version: 1.0
In-Reply-To: <20130201085053.GG8060@arwen.pp.htv.fi>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
	<510A56BF.3040804@ti.com>
	<CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
	<20130131152527.GE4064@arwen.pp.htv.fi>
	<CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
	<20130131153836.GF4064@arwen.pp.htv.fi>
	<510B50DA.6010201@ti.com>
	<CAFp+6iF2HMmiMVR4YyEG7bmpCZ4KdwBT7q2Jy-P1SMVtoVBn6g@mail.gmail.com>
	<CAFp+6iGZU29nt4yBjkyeeS+s_D1=AamgGTOsJq1xo_5z2O-sDg@mail.gmail.com>
	<20130201085053.GG8060@arwen.pp.htv.fi>
Date: Fri, 1 Feb 2013 14:23:28 +0530
Message-ID: <CAFp+6iFBL8LOh=dw=mvHaUHjKvmLr0of83dmC6wf4zHog8xubw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt node.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: kishon <kishon@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Fri, Feb 01, 2013 at 11:54:01AM +0530, Vivek Gautam wrote:
>> Hi Balbi,
>>
>>
>> On Fri, Feb 1, 2013 at 11:52 AM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
>> > Hi Kishon,
>> >
>> >
>> > On Fri, Feb 1, 2013 at 10:51 AM, kishon <kishon@ti.com> wrote:
>> >> Hi,
>> >>
>> >>
>> >> On Thursday 31 January 2013 09:08 PM, Felipe Balbi wrote:
>> >>>
>> >>> On Thu, Jan 31, 2013 at 09:00:37PM +0530, Vivek Gautam wrote:
>> >>>>
>> >>>> Hi Felipe,
>> >>>>
>> >>>>
>> >>>> On Thu, Jan 31, 2013 at 8:55 PM, Felipe Balbi <balbi@ti.com> wrote:
>> >>>>>
>> >>>>> Hi,
>> >>>>>
>> >>>>> On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
>> >>>>>>>>
>> >>>>>>>> Moreover, SoCs having multiple dwc3 controllers will have multiple
>> >>>>>>>> PHYs, which eventually be added using usb_add_phy_dev(), and not
>> >>>>>>>> using usb_add_phy(). So each dwc3 controller won't be able to
>> >>>>>>>> get PHYs by simply calling devm_usb_get_phy() also.
>> >>>>>>>
>> >>>>>>>
>> >>>>>>> No. We have added usb_get_phy_dev() for that purpose in the case of
>> >>>>>>> non-dt.
>> >>>>>>> I think, instead you can have a patch to use devm_usb_get_phy_dev()
>> >>>>>>> here and
>> >>>>>>> in exynos platform specific code use usb_bind_phy() to bind the phy
>> >>>>>>> and
>> >>>>>>> controller till you change it to dt.
>> >>>>>>>
>> >>>>>>
>> >>>>>> We have dt support for dwc3-exynos, in such case we should go ahead
>> >>>>>> with
>> >>>>>> of_platform_populate(), right ?
>> >>>>>> But if when i use of_platform_populate() i will not be able to set
>> >>>>>> dma_mask to dwc3->dev. :-(
>> >>
>> >>
>> >> You can do something like this
>> >>
>> >> static u64 dwc3_exynos_dma_mask = DMA_BIT_MASK(32);
>> >>
>> >> static int dwc3_exynos_set_dmamask(struct device *dev, void *c)
>> >> {
>> >>         dev->dma_mask = &dwc3_exynos_dma_mask;
>> >>
>> >>         return 0;
>> >> }
>> >>
>> >> And in your probe after of_platform_populate, you can add
>> >>
>> >> device_for_each_child(&pdev->dev, NULL, dwc3_exynos_set_dmamask);
>> >>
>> >> Here pdev is the platform device of dwc3-exynos. By this way all the
>> >> children of dwc3-exynos will have dma_mask set to the required value.
>> >>
>> >
>> > Nice idea, thanks :-)
>> > hmm.. so i can patch this now, and get things working ;-)
>> >
>>
>> If this is fine with you shall i go ahead and post a patch for the same ? ;-)
>
> should be fine, but we can wait a bit to see if DeviceTree folks reply,
> your patch will only go on v3.10 anyway.
>

Yeah, sure. No problem at all.
For the time being i will continue to use this change for my other
development work too. :-)


-- 
Thanks & Regards
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3B0Ixc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:53:32 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56411 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3B0Ix3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130227080617.GD8016@arwen.pp.htv.fi>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
	<1359373348-18320-3-git-send-email-gautam.vivek@samsung.com>
	<20130128114554.GE28698@arwen.pp.htv.fi>
	<CAFp+6iFcZwu3=2u5ig_F14UKxTXwb2Czrv3JjCqR6QGLPHzFqg@mail.gmail.com>
	<20130227080617.GD8016@arwen.pp.htv.fi>
Date: Wed, 27 Feb 2013 14:23:27 +0530
Message-ID: <CAFp+6iH0pDPV9bZ32m6sS1fCRF4E+Z0ocgwMtodji3RT=akGJA@mail.gmail.com>
Subject: Re: [PATCH 2/4] USB: dwc3: Adjust runtime pm the dwc3 driver to allow
 runtime suspend
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Wed, Feb 27, 2013 at 1:36 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> sorry for the delay
>

That's alright ;-)

> On Mon, Jan 28, 2013 at 07:06:56PM +0530, Vivek Gautam wrote:
>> Hi Felipe,
>>
>>
>> On Mon, Jan 28, 2013 at 5:15 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > On Mon, Jan 28, 2013 at 05:12:26PM +0530, Vivek Gautam wrote:
>> >> The current code in the dwc3 probe effectively disables runtime pm
>> >> from ever working because it calls a get() that was never put() until
>> >> device removal.  Change the runtime pm code to match the standard
>> >> formula and allow runtime pm to function.
>> >>
>> >> Note that this doesn't enable full runtime pm on the DWC3 device in
>> >> that the port isn't put into a lower power mode when not used.
>> >> However it does allow users of dwc3 (like dwc3-exynos) to do some
>> >> amount of runtime power management.
>> >>
>> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> >> ---
>> >>  drivers/usb/dwc3/core.c |    4 +++-
>> >>  1 files changed, 3 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> >> index 3a4004a..59c2494 100644
>> >> --- a/drivers/usb/dwc3/core.c
>> >> +++ b/drivers/usb/dwc3/core.c
>> >> @@ -453,6 +453,7 @@ static int dwc3_probe(struct platform_device *pdev)
>> >>       if (of_get_property(node, "tx-fifo-resize", NULL))
>> >>               dwc->needs_fifo_resize = true;
>> >>
>> >> +     pm_runtime_set_active(dev);
>> >
>> > this usage of pm_runtime_set_active() actually makes me a bit scared. At
>> > least OMAP starts with the device switched off, so this will probably
>> > break OMAP at least.
>>
>> I am fine with dropping pm_runtime_set_active(), actually thought
>> to put device in active state so that as and when system finds it idle,
>> force into suspend state.
>>
>> I fact should i drop  pm_runtime_set_active() calls from other places too
>> (xhci-plat, dwc3-exynos, and samsung-usb3 phy) and call get_sync() alongwith
>> enable() ?
>
> that's correct, make sure it works fine for you ;-)
>
Yeah sure.


-- 
Thanks & Regards
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3COGGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:06:06 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:44221 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3COGGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130314105320.GH32369@arwen.pp.htv.fi>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
	<1363257898-17504-3-git-send-email-gautam.vivek@samsung.com>
	<20130314105320.GH32369@arwen.pp.htv.fi>
Date: Fri, 15 Mar 2013 11:36:00 +0530
Message-ID: <CAFp+6iEHVi4W-be4t1k3K=Yz8OP150rtBmNKXR0xnFiA3Oa3qg@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb: dwc3: exynos: use clk_prepare_enable and clk_disable_unprepare
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        dianders@chromium.org, kishon <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Mar 14, 2013 at 4:23 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Mar 14, 2013 at 04:14:58PM +0530, Vivek Gautam wrote:
>> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
>> calls as required by common clock framework.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> CC: Felipe Balbi <balbi@ti.com>
>> CC: Kukjin Kim <kgene.kim@samsung.com>
>> ---
>>  drivers/usb/dwc3/dwc3-exynos.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
>> index 66ca9ac..b03f609 100644
>> --- a/drivers/usb/dwc3/dwc3-exynos.c
>> +++ b/drivers/usb/dwc3/dwc3-exynos.c
>> @@ -129,7 +129,7 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
>>       exynos->dev     = dev;
>>       exynos->clk     = clk;
>>
>> -     clk_enable(exynos->clk);
>> +     clk_prepare_enable(exynos->clk);
>
> eventually we need to pass this clock handling to dwc3/core.c. Just make
> sure it's optional since not all platforms need it.
>
True, as of now i could see only exynos platform getting a device
clock for dwc3-glue.
So, if not all platforms need to do this, why should we plan to move
this to dwc3/core.c ?

> I guess the best way would be to handle clocks via
> ->runtime_suspend()/->runtime_resume() ??

Right, but there was a doubt actually if you can please clear that.
In device probe, after enabling runtime_pm we would need to
'pm_runtime_get_sync' the device.
Thereby, in runtime_resume the clocks will be enabled.
Now as soon as the device probe finishes, the device will go in
suspend state, calling runtime_suspend
and the clocks would be disabled.
Now would it be possible for the controller to detect any connect/disconnect.

Pardon me if there is something very silly i am missing out.

>
> --
> balbi



-- 
Thanks & Regards
Vivek

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611Ab3DCGFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:05:47 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45217 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762557Ab3DCGFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130402082952.GG30286@arwen.pp.htv.fi>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
	<1364824448-14732-3-git-send-email-gautam.vivek@samsung.com>
	<20130402082952.GG30286@arwen.pp.htv.fi>
Date: Wed, 3 Apr 2013 11:35:43 +0530
Message-ID: <CAFp+6iFv43Xbck1cy8AcvGzBrxOECHLjowfV7askCCYgFFgNrQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] USB: dwc3: Adjust runtime pm to allow autosuspend
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, sarah.a.sharp@linux.intel.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        dianders@chromium.org, t.figa@samsung.com, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Tue, Apr 2, 2013 at 1:59 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Apr 01, 2013 at 07:24:01PM +0530, Vivek Gautam wrote:
>> The current code in the dwc3 probe effectively disables runtime pm
>> from ever working because it calls a get() that was never put() until
>> device removal.  Change the runtime pm code to match the standard
>> formula and allow runtime pm to function.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> CC: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/usb/dwc3/core.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index e2325ad..3a6993c 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -491,6 +491,11 @@ static int dwc3_probe(struct platform_device *pdev)
>>
>>       dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
>>
>> +     /* Setting device state as 'suspended' initially,
>
> wrong comment style.
Yea :-(  will fix this.

>
>> +      * to make sure we know device state prior to
>> +      * pm_runtime_enable
>> +      */
>> +     pm_runtime_set_suspended(dev);
>
> didn't Alan mention this should be done at the Bus level ? In that case,
> shouldn't you have call pm_runtime_set_active/suspended() based on
> DT's status=okay or status=disabled ? Or something similar ?

True, we should be doing this at bus level. But he did also mention to
let pm core
know of the state of the device before enabling the runtime pm. Right ?
Moreover immediately after pm_runtime_enable(), we do pm_runtime_get_sync()
so that device comes to active state.
I am possibly missing things out here, not able to grab this whole
picture completely :-(

Wouldn't DT's status=disabled actually be disabling the device as a whole ?
So, how much will runtime power management on the device be affecting ?



-- 
Thanks & Regards
Vivek

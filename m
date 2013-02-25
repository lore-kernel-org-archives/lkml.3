Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3BYJ3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:29:35 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63827 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3BYJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:29:33 -0500
MIME-Version: 1.0
In-Reply-To: <20130225091935.GF25749@arwen.pp.htv.fi>
References: <1360071958-20797-1-git-send-email-gautam.vivek@samsung.com>
	<20130225081723.GD25749@arwen.pp.htv.fi>
	<CAFp+6iHaP96F0OF9_C1DTsfmkPNZMVC78tj7m0YGdV=d_znWrA@mail.gmail.com>
	<20130225091935.GF25749@arwen.pp.htv.fi>
Date: Mon, 25 Feb 2013 14:59:31 +0530
Message-ID: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 2:49 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Feb 25, 2013 at 02:21:46PM +0530, Vivek Gautam wrote:
>> >> @@ -514,6 +511,14 @@ static int dwc3_probe(struct platform_device *pdev)
>> >>       }
>> >>       dwc->mode = mode;
>> >>
>> >> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
>> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_HOST);
>> >> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
>> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_DEVICE);
>> >> +#else
>> >> +     dwc3_set_mode(dwc, DWC3_GCTL_PRTCAP_OTG);
>> >> +#endif
>> >
>> > you can actually use:
>> >
>> > if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
>> >         dwc3_set_mode(dwc...
>> > else if (IS_ENABLED( ...
>> >         ...
>> > else
>> >         ...
>> >
>>
>> I am actually hoping to change this to something like below (after
>> of course changing the preprocessor conditionals) :
>>
>> commit 9a62ed948dcb6ac5d78aff41f5355c0a5ea86475
>> Author: Vivek Gautam <gautam.vivek@samsung.com>
>> Date:   Thu Jan 24 11:58:05 2013 +0530
>>
>>     usb: dwc3: Set GCTL.PrtCapDir based on selected mode.
>>
>>     Now that machines may select the mode of working of DWC3,
>>     we can set the Port capability direction based on selected mode.
>>
>>     Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 79f335f..9444fbe 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -478,7 +478,13 @@ static int dwc3_probe(struct platform_device *pdev)
>>                 goto err1;
>>         }
>>
>> -       mode = DWC3_MODE(dwc->hwparams.hwparams0);
>> +#if IS_ENABLED(CONFIG_USB_DWC3_HOST)
>> +       mode = DWC3_MODE_HOST;
>> +#elif IS_ENABLED(CONFIG_USB_DWC3_GADGET)
>> +       mode = DWC3_MODE_DEVICE;
>> +#else
>> +       mode = DWC3_MODE_DRD;
>
> looks alright.
>
Fine then, i'll post this.


-- 
Thanks & Regards
Vivek

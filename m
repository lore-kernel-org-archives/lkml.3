Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbaDWHdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:33:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33625 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDWHd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:33:27 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-04-53576cc340ae
Message-id: <53576CC6.1010302@samsung.com>
Date: Wed, 23 Apr 2014 09:33:26 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com
Subject: Re: [PATCH v2 05/13] extcon: extcon-class: improve extcon client API
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
 <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
 <20140419105225.GB976@ambient.musicnaut.iki.fi> <53560A6F.8030909@samsung.com>
 <20140422150336.GA612@drone.musicnaut.iki.fi>
In-reply-to: <20140422150336.GA612@drone.musicnaut.iki.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0iTYRjHefcd9jlcfR5Wb1JIglArLcPoRUxMgt6LxEA6SZRLlwqbypaW
	3TQVBS3dzHJp5nm56VTylJNt5hwWpqIoepFH1FLTzJhoJZrbbrz7PQ+///O/eRjCfZb0YhIS
	H4pliSKJD80jv+x8GvXrkdyMPGucY5B+MRR1t51E3dNP0bjtO4VezK8RqNw6SKECXSGBlCuV
	FFK2XkYftzsAyqxuotHgsg6gnIF5Ag0tPKeRxlxPosrsGhKNdJbS6E2NkkRV77IINF/Zz0EN
	1kku0owPc9DXdC2Nald3aaRSN5CocUlNoiyTlYvMQ9sUanr9gww9hvVleoBH8vM4uNNQSmGV
	8jfAhpJJLtbV2mjcs1FJ4hatEDfX5dB4ub6YwhNjRhp3vdVzcV7mTxovFfyjsWFTwcX5rXXg
	mkcULzhWLElIFcvOhETz4gcVL6lkDfM43fSZVoBeOhe4MJANhArLLNfJh+DQVNPense4sxoA
	26pnOM5hHUBTo82R4LNCWFNvIOxMsr6wLGOUY2eaPQ1bN1XAzgL2FpxK76GcvhvcKpwi7ezJ
	noDLZiVlP0qwGgoaf5kcYQ82HA6MjZPOtgwOzLL2OdIubBAsrCh1SMReQ1dWEe1kb9iiXyVU
	gC3ZV1KyTyvZp1UAog4IxCkxyfL7cdIAf7lIKk9JjPOPSZI2A+db2DpAdW+QBbAM8HHlw9ob
	ke6UKFWeJrUAyBA+nvzi9b0VP1aU9kQsS7onS5GI5RbAYVy8FCDgwaR3y1DYuaMXXOmEq1d8
	Dy7mSi4eidae/5YxYZ1TG3yZZwduC7Y82gWPOu+szI18+BPovp02o5F29WnwXYFaNwzag/6G
	TwdfD39vM1eZD5dvrLtFXFKHrWl3UrVrcIH17TdWaLOrhH7qVyERxyOiLHx5cdH07qmKAD5Z
	FuVDyuNFAUJCJhf9Bwh/KOX0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 05:03 PM, Aaro Koskinen wrote:
> Hi,
> 
> On Tue, Apr 22, 2014 at 08:21:35AM +0200, Robert Baldyga wrote:
>> On 04/19/2014 12:52 PM, Aaro Koskinen wrote:
>>> On Mon, Apr 14, 2014 at 01:46:16PM +0200, Robert Baldyga wrote:
>>>>  	dev_info(&pdev->dev,
>>>> -		 "OMAP USB OTG controller rev %d.%d (%s, id=%d, vbus=%d)\n",
>>>> -		 (rev >> 4) & 0xf, rev & 0xf, config->extcon, otg_dev->id,
>>>> +		 "OMAP USB OTG controller rev %d.%d (id=%d, vbus=%d)\n",
>>>> +		 (rev >> 4) & 0xf, rev & 0xf, otg_dev->id,
>>>>  		 otg_dev->vbus);
>>>
>>> This change is unrelated to the patch and not needed.
>>>
>>
>> It's related because we no longer use config->extcon since we have
>> cable-oriented API. We can keep displaying it, but this value is
>> actually meaningless.
> 
> It's not completely meaningless, as the cable is searched using that name.
> 

Yes, I see, you're right. I have forgot that this driver doesn't use
devicetree. I will restore displaying extcon name.

Thanks!
Robert Baldyga
Samsung R&D Institute Poland


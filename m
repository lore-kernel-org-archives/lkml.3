Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaEINzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 09:55:38 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:62304 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEINzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 09:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iEGvy71s=-Vt37TKkVDUX1wO6GZdwL=uBfPjng78yE5-A@mail.gmail.com>
References: <1398665874-31238-1-git-send-email-gautam.vivek@samsung.com>
	<5368F136.6070804@samsung.com>
	<CAFp+6iHN-W-k6ow5YykK_QWgBJ+GgzXwPX6suWtizxwJWOiGtg@mail.gmail.com>
	<CAFp+6iF=Z_dkd+YJm2-ODmvgZ6PCt+bUx+vSVm_5RtobVN0WfA@mail.gmail.com>
	<536CAA4F.8050404@samsung.com>
	<CAFp+6iEGvy71s=-Vt37TKkVDUX1wO6GZdwL=uBfPjng78yE5-A@mail.gmail.com>
Date: Fri, 9 May 2014 19:25:34 +0530
X-Google-Sender-Auth: k9ih7csnecUB7DHvj8nAJYhoqEE
Message-ID: <CAFp+6iFJ1aXEvss1Wwx=Y=sk5j3m57zwL5Hh3wYUorUNi96MGA@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] phy: Add new Exynos5 USB 3.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, "robh+dt" <robh+dt@kernel.org>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        kishon <kishon@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 4:21 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Hi Sylwester,
>
>
> On Fri, May 9, 2014 at 3:43 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> Hi Vivek,
>>
>> On 08/05/14 11:03, Vivek Gautam wrote:
>>>>>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>> >>> index b422e38..51efe4c 100644
>>>>>> >>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>> >>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>>>>>> >>> @@ -114,3 +114,43 @@ Example:
>>>>>> >>>               compatible = "samsung,exynos-sataphy-i2c";
>>>>>> >>>               reg = <0x38>;
>>>>>> >>>       };
>>>>>> >>> +
>>>>>> >>> +Samsung Exynos5 SoC series USB DRD PHY controller
>>>>>> >>> +--------------------------------------------------
>>>>>> >>> +
>>>>>> >>> +Required properties:
>>>>>> >>> +- compatible : Should be set to one of the following supported values:
>>>>>> >>> +     - "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>>>>>> >>> +     - "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>>>>>> >>> +- reg : Register offset and length of USB DRD PHY register set;
>>>>>> >>> +- clocks: Clock IDs array as required by the controller
>>>>>> >>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>>>>>> >>> +            Required clocks:
>>>>>> >>> +     - phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
>>>>>> >>> +            used for register access.
>>>>>> >>> +     - ref: PHY's reference clock (usually crystal clock), used for
>>>>>> >>> +            PHY operations, associated by phy name. It is used to
>>>>>> >>> +            determine bit values for clock settings register.
>>>>>> >>> +            For Exynos5420 this is given as 'sclk_usbphy30' in CMU.
>>>>>> >>> +- samsung,pmu-syscon: phandle for PMU system controller interface, used to
>>>>>> >>> +                   control pmu registers for power isolation.
>>>>>> >>> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
>>>>>> >>> +                   base.
>>>>> >>
>>>>> >> It doesn't seem right to have register offset encoded in the device tree
>>>>> >> like this. I think it'd be more appropriate to associate such an offset
>>>>> >> with the compatible string's value in the driver.
>>>> >
>>>> > Ok, it makes more sense.
>>>> > Just out of curiosity, what difference would this make ?
>>>
>>> Moreover, in case of Exynos5420 (and may be in future SoCs), where we
>>> have 2 USB DRD PHY controllers,
>>> we will need to have a way around to deal with two separate offsets in
>>> the driver for one compatible string.
>>
>> It could be handled by creating a list of offsets per compatible string and
>> then adding some way to identify the PHY device instance. So I believe that's
>> not a big issue.
>
> True, we had tried to make use of 'aliases' for multiple controllers
> on Exynos5420,
> in earlier version V3 of this patch, to handle the pmu-register
> offsets in _somewhat_ similar fashion. [1]
> But then we had to drop that as per the suggestions in the mailing list.
>
>> Now you'd be encoding a list of registers offsets in the
>> device tree, without encoding bit layout of each register. It's unlikely that
>> each instance would have different bits layout, but describing individual
>> registers in DT I thought is something that we're not supposed to do.
>
> Ok, so this is information to me, i was not very much aware of this.
> Thanks for explaining it here.
>
>>
>>> Getting the offsets from DT seems a cleaner way to handle this case of
>>> multi controllers.
>>
>> I think it's easier from the driver POV, but isn't it violating the device
>> tree rules ?
>> Anyway. I'm just pointing this minor issue in the binding as it appears
>> to me. The final word of course belongs to a DT binding maintainer.
>
> Thanks Sylwester, for pointing this out here.
> Meantime, please let me know if the approach using aliases is one
> possible solution for this or not ?

I shall be sending v8 patch series for this, in order to use 'aliases'
in the driver
to get the distinction between pmu-offsets.
So, v8 will give an alternative approach for getting pmu-offsets using
macro definitions from a header file.

Mark and Rob can suggest us which can be a better approach.

>
>
> [1] [PATCH v3] phy: Add new Exynos5 USB 3.0 PHY driver
>      https://lkml.org/lkml/2014/1/21/46



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India

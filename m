Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbaETFMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:12:19 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54532 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaETFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:12:18 -0400
MIME-Version: 1.0
In-Reply-To: <5379E2FA.4080202@gmail.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
	<1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
	<5373CBAD.2010505@gmail.com>
	<CAPdUM4MT0nZcLRtNcKRAeW4Q3n5z9n4BnzR-7uYMb1gqwEhWXA@mail.gmail.com>
	<53753527.3000905@gmail.com>
	<CAPdUM4M5k-aouSA=dyUXWOyFLBhob+o8103a=gAxo-O68i-MCw@mail.gmail.com>
	<CAPdUM4Py4r3ZV79ULcJ3KojaPQ0hfZTE2XbsY+=hP4LD70mb8Q@mail.gmail.com>
	<5375ED80.2010008@samsung.com>
	<CAPdUM4Mfe4xTnh-qPeazcknbCoqX3HcORKHLqBE9ukqa4ULi9A@mail.gmail.com>
	<53762583.5020907@samsung.com>
	<CAPdUM4OWbDBDNsaETT64sbLs_We40ZeV2WVh09Jkdx_ZPoms4Q@mail.gmail.com>
	<5379E2FA.4080202@gmail.com>
Date: Tue, 20 May 2014 10:42:15 +0530
X-Google-Sender-Auth: zEzjj83GY-ouKT2bFUu8z2hBGJ0
Message-ID: <CAPdUM4N4Exgrta1rUgUXi-+bwDiwLrHqH0Yu4U2NLDVcJBF6ZQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        PANKAJ KUMAR DUBEY <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 May 2014 16:24, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 19.05.2014 09:10, Rahul Sharma wrote:
>> On 16 May 2014 20:19, Tomasz Figa <t.figa@samsung.com> wrote:
>>> On 16.05.2014 16:30, Rahul Sharma wrote:
>>>> On 16 May 2014 16:20, Tomasz Figa <t.figa@samsung.com> wrote:
>>>>> On 16.05.2014 12:35, Rahul Sharma wrote:
>>>>>> On 16 May 2014 15:12, Rahul Sharma <rahul.sharma@samsung.com> wrote:
>>>>>>> On 16 May 2014 03:14, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>>>>>>> On 15.05.2014 06:01, Rahul Sharma wrote:
>>>>>> [snip]
>>>>>>>>>> the PHY provider.
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Please correct me if I got you wrong. You want somthing like this:
>>>>>>>>>
>>>>>>>>> pmu_system_controller: system-controller@10040000 {
>>>>>>>>>          ...
>>>>>>>>>           simple_phys: simple-phys {
>>>>>>>>>                         compatible = "samsung,exynos5420-simple-phy";
>>>>>>>>>                         ...
>>>>>>>>>           };
>>>>>>>>> };
>>>>>>>>
>>>>>>>> Not exactly.
>>>>>>>>
>>>>>>>> What I meant is that the PMU node itself should be the PHY provider, e.g.
>>>>>>>>
>>>>>>>> pmu_system_controller: system-controller@10040000 {
>>>>>>>>         /* ... */
>>>>>>>>         #phy-cells = <1>;
>>>>>>>> };
>>>>>>>>
>>>>>>>> and then the PMU node should instantiate the Exynos simple PHY driver,
>>>>>>>> as this is a driver for a facility existing entirely inside of the PMU.
>>>>>>>> Moreover, the driver should be rather called Exynos PMU PHY.
>>>>>>>>
>>>>>>>> I know this isn't really possible at the moment, but with device tree we
>>>>>>>> must design things carefully, so it's better to take a bit more time and
>>>>>>>> do things properly.
>>>>>>>>
>>>>>>>> So my opinion on this is that there should be a central Exynos PMU
>>>>>>>> driver that claims the IO region and instantiates necessary subdrivers,
>>>>>>>> such as Exynos PMU PHY driver, Exynos CLKOUT driver, Exynos cpuidle
>>>>>>>> driver and more, similar to what is being done in drivers/mfd.
>>>>>>>
>>>>>>
>>>>>> Hi Tomasz,
>>>>>>
>>>>>> These PHYs are not part of PMU as such. I am not sure if it is correct to
>>>>>> probe them as phy provider for all these phys. Only relation of these phys with
>>>>>> the PMU is 'enable/disable control'.
>>>>>
>>>>> Well, in reality what is implemented by this driver is not even a PHY,
>>>>> just some kind of power controllers, which are contained entirely in the
>>>>> PMU.
>>>>>
>>>>
>>>> I agree. Actually the role of generic phy framework for these 'simple' phys is
>>>> only that much.
>>>>
>>>>>> Controlling this bit using regmap interface
>>>>>> still looks better to me.
>>>>>
>>>>> Well, when there is a choice between using regmap and not using regmap,
>>>>> I'd rather choose the latter. Why would you want to introduce additional
>>>>> abstraction layer if there is no need for such?
>>>>>
>>>>>>
>>>>>> IMHO Ideal method would be probing these PHYs independently and resolving
>>>>>> the necessary dependencies like syscon handle, clocks etc. This way we will
>>>>>> not be having any common phy provider for all these independent PHYs and it
>>>>>> would be clean to add each of these phy nodes in DT. Please see my original
>>>>>> comment below.
>>>>>>
>>>>>> http://lkml.iu.edu/hypermail/linux/kernel/1404.1/00701.html
>>>>>
>>>>> With the solution I proposed, you don't need any kind of dependencies
>>>>> for those simple power controllers. They are just single bits that don't
>>>>> need anything special to operate, except PMU clock running.
>>>>
>>>> In that case we can further trim it down and let the drivers use the regmap
>>>> interface to control this bit. Many drivers including HDMI, DP just need that
>>>> much functionality from the phy provider.
>>>
>>> Well, this is what several drivers already do, like USB PHY (dedicated
>>> IP block), watchdog (for watchdog mask), SATA PHY (dedicated IP block
>>> too) or will do, like I2C (for configuration of I2C mux on Exynos5).
>>>
>>> At least this would be consistent with them and wouldn't be an API
>>> abuse, so I'd be inclined to go this way more than introducing
>>> abstractions like this patch does.
>>
>> Ok. I had already posted a patch for this at
>> http://www.spinics.net/lists/linux-samsung-soc/msg28049.html
>> I will revive that thread.
>
> Looks good to me.
>
>>
>> @Tomasz Stanislawski, Do you have different opinion here?
>
> I'm afraid Tomasz might not be very responsive during next few days, as
> he is on a business trip. You might be able to reach him on our internal
> communicator, though.

Thanks Tomasz,

I will contact him over communicator.

Regards.

>
> Best regards,
> Tomasz
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

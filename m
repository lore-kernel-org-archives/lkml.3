Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbaEPKfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:35:52 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51946 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711AbaEPKfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAPdUM4M5k-aouSA=dyUXWOyFLBhob+o8103a=gAxo-O68i-MCw@mail.gmail.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
	<1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
	<5373CBAD.2010505@gmail.com>
	<CAPdUM4MT0nZcLRtNcKRAeW4Q3n5z9n4BnzR-7uYMb1gqwEhWXA@mail.gmail.com>
	<53753527.3000905@gmail.com>
	<CAPdUM4M5k-aouSA=dyUXWOyFLBhob+o8103a=gAxo-O68i-MCw@mail.gmail.com>
Date: Fri, 16 May 2014 16:05:48 +0530
X-Google-Sender-Auth: JV4lvuThK0NhfLtelBESPLYOoiQ
Message-ID: <CAPdUM4Py4r3ZV79ULcJ3KojaPQ0hfZTE2XbsY+=hP4LD70mb8Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
From: Rahul Sharma <rahul.sharma@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        PANKAJ KUMAR DUBEY <pankaj.dubey@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        sunil joshi <joshi@samsung.com>, Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 15:12, Rahul Sharma <rahul.sharma@samsung.com> wrote:
> On 16 May 2014 03:14, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> On 15.05.2014 06:01, Rahul Sharma wrote:
[snip]
>>>> the PHY provider.
>>>>
>>>
>>> Please correct me if I got you wrong. You want somthing like this:
>>>
>>> pmu_system_controller: system-controller@10040000 {
>>>          ...
>>>           simple_phys: simple-phys {
>>>                         compatible = "samsung,exynos5420-simple-phy";
>>>                         ...
>>>           };
>>> };
>>
>> Not exactly.
>>
>> What I meant is that the PMU node itself should be the PHY provider, e.g.
>>
>> pmu_system_controller: system-controller@10040000 {
>>         /* ... */
>>         #phy-cells = <1>;
>> };
>>
>> and then the PMU node should instantiate the Exynos simple PHY driver,
>> as this is a driver for a facility existing entirely inside of the PMU.
>> Moreover, the driver should be rather called Exynos PMU PHY.
>>
>> I know this isn't really possible at the moment, but with device tree we
>> must design things carefully, so it's better to take a bit more time and
>> do things properly.
>>
>> So my opinion on this is that there should be a central Exynos PMU
>> driver that claims the IO region and instantiates necessary subdrivers,
>> such as Exynos PMU PHY driver, Exynos CLKOUT driver, Exynos cpuidle
>> driver and more, similar to what is being done in drivers/mfd.
>

Hi Tomasz,

These PHYs are not part of PMU as such. I am not sure if it is correct to
probe them as phy provider for all these phys. Only relation of these phys with
the PMU is 'enable/disable control'. Controlling this bit using regmap interface
still looks better to me.

IMHO Ideal method would be probing these PHYs independently and resolving
the necessary dependencies like syscon handle, clocks etc. This way we will
not be having any common phy provider for all these independent PHYs and it
would be clean to add each of these phy nodes in DT. Please see my original
comment below.

http://lkml.iu.edu/hypermail/linux/kernel/1404.1/00701.html

Regards,
Rahul Sharma

>
>>
>> Now, there is already ongoing effort to convert current freestanding PMU
>> configuration code in mach-exynos into a full-fledged PMU driver, but
>> not exactly in the same direction as I stated above. I'll try to
>> cooperate with Pankaj, who is responsible for this work to make this go
>> into the right track.
>>
>> Best regards,
>> Tomasz
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel

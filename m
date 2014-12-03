Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaLCIge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:36:34 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29195 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLCIgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:36:32 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-1e-547ecb8dd160
Message-id: <547ECB8B.3040905@samsung.com>
Date: Wed, 03 Dec 2014 09:36:27 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        amit daniel kachhap <amit.daniel@samsung.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@kernel.org>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC v2 08/12] soc: samsung: pm_domain: Add support for
 parent power domain
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-8-git-send-email-amit.daniel@samsung.com>
 <CAPDyKFoBnViXQF=wDYp0x4gaOO4ht3a8KBeY6=k6_Zkkav28pQ@mail.gmail.com>
 <CADGdYn4Vi2wV1y3Y0cTbPL0cFR2EEV7jT=82fHNYu+=xwZ7mBA@mail.gmail.com>
 <CAMuHMdX+rcmUM+_4c72b16Zs_c5KMhO3bYSH5-AUp087cwGdeA@mail.gmail.com>
In-reply-to: <CAMuHMdX+rcmUM+_4c72b16Zs_c5KMhO3bYSH5-AUp087cwGdeA@mail.gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xy7q9p+tCDHonslo0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHcdmkpOZklqUW6dsl
	cGVM3PGHpWCRcMWlp19ZGxiv8nUxcnJICJhI3L7/mBXCFpO4cG89WxcjF4eQwFJGiWV3dkM5
	nxgljn++wA5SxSugJbH/3G4WEJtFQFWifVY3WDebgKFE19suNhBbVCBGYvHC1cwQ9YISPybf
	A6rn4BARiJP4dZITZCazwHYWiVe7nrCBxIUFEiRmX1SG2DWdWeLRkk2MIL2cAsESC/ctAJvD
	LGAm8eXlYVYIW15i85q3zBMYBWYhWTELSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl
	5+duYoREzJcdjIuPWR1iFOBgVOLhVZhSFyLEmlhWXJl7iFGCg1lJhHfZDqAQb0piZVVqUX58
	UWlOavEhRiYOTqkGRrWPk5bvK1D7FrIuwi+hLKP126f1ZyqKMwobA+NNEufU/854t2ybfUBO
	c9nuVwd05Ezcn0rv2d8VUdt0kZUn2d3uhlRRco/FnO+up/tn2lhUHiux79gouu4e+7X/8b/b
	bpyrKYz5ezmz+WXLZ3l/VXfjrWu2PT8mvkNx9cwY5TUzf97i/+P4SImlOCPRUIu5qDgRAHLg
	Xsl2AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-11-25 10:19, Geert Uytterhoeven wrote:
> On Tue, Nov 25, 2014 at 9:57 AM, amit daniel kachhap
> <amit.daniel@samsung.com>  wrote:
>>>> diff --git a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>>> index 00ebda1..0160bdc 100644
>>>> --- a/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>>> +++ b/Documentation/devicetree/bindings/arm/exynos/power_domain.txt
>>>> @@ -24,6 +24,7 @@ Optional Properties:
>>>>          - pclkN, clkN: Pairs of parent of input clock and input clock to the
>>>>                  devices in this power domain. Maximum of 4 pairs (N = 0 to 3)
>>>>                  are supported currently.
>>>> +- parents: phandle of parent power domains.
> Why not using just "power-domains = <&pd_top>"?
> This is consistent with how clocks refer to their parent clocks.

I agree. The only question is weather exynos dts should keep using 
samsung,power-domain
property, or switch to generic 'power-domains' approach. I assume that 
exynos-pm driver
should support both.

>>>>   Node of a device using power domains must have a samsung,power-domain property
>>>>   defined with a phandle to respective power domain.
>>>> @@ -48,6 +49,7 @@ Example:
>>>>          mfc_pd: power-domain@10044060 {
>>>>                  compatible = "samsung,exynos4210-pd", "samsung,exynos7-pd-mfc";
>>>>                  reg = <0x10044060 0x20>;
>>>> +               parents = <&pd_top>;
>>>>                  #power-domain-cells = <0>;
>>>>          };
>>> This seems like a good and generic approach to describe that a PM
>>> domain could have a parent. I would suggest to rename it, such it
>>> reflects its a PM domain binding though.
>> I am not sure if this is generic. I guess PD's represented like below
>> are more generic.
>> PD1 {
>>          PD2 {
>>                  PD3 {
>>                  };
>>          };
>> };
> Such a representation is not always possible.
> If you have one power-controller for a hierarchy of PM domains, you can
> use it.
> If you have multiple power-controllers, the power controller nodes are at the
> same level in DT, so you'll have to use "power-domains" properties to link
> them together.

I agree. I will send updated patch for this purpose for existing exynos4 
power domain driver.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


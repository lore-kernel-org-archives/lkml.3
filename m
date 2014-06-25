Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaFYFma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:42:30 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29456 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaFYFm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:42:28 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-32-53aa613c0f81
Message-id: <53AA613C.4060807@samsung.com>
Date: Wed, 25 Jun 2014 07:42:20 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>, "'Daniel Drake'" <drake@endlessm.com>
Cc: linux-kernel@vger.kernel.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        linux-usb@vger.kernel.org, kishon@ti.com,
        Tomasz Figa <t.figa@samsung.com>, gautam.vivek@samsung.com
Subject: Re: [PATCH] phy: phy-samsung-usb2: Change phy power on/power off
 sequence
References: <1403614495-9291-1-git-send-email-k.debski@samsung.com>
 <CAD8Lp441832-ZVV8FQChEXcLqVpZqygv3iaF95_SfZOH_xkFPg@mail.gmail.com>
 <074a01cf8fc1$e906f0c0$bb14d240$%debski@samsung.com>
In-reply-to: <074a01cf8fc1$e906f0c0$bb14d240$%debski@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7o2iauCDVoXcVs8mv+Y2aLtykF2
	ix+vL7BZXHjaw2ZxedccNosZ5/cxWSxa1spssX7GaxYHDo9F37M8+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGbfvXGQqeM5b0bvQsoGxlbuLkYNDQsBEYsFFli5GTiBTTOLCvfVs
	XYxcHEICSxklzly+wQThfGKUePKvBayKV0BL4unqA2A2i4CqRPei5cwgNpuAoUTX2y42EFtU
	IEbiTO9nZoh6QYkfk++B1YsI+EicP7KeGWQos8BRRonXm4+wgySEBUIklnStY4TYdpBR4tfC
	tWCTOAUcJXbuWwVmMwuYSTxqWccMYctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR1NLkguKk
	9FxDveLE3OLSvHS95PzcTYyQIP+yg3HxMatDjAIcjEo8vAE8q4KFWBPLiitzDzFKcDArifBe
	8gIK8aYkVlalFuXHF5XmpBYfYmTi4JRqYIyfZKhco2nd8axRh93hRaTQknO6HrE1Lx55ZC3W
	ifhjMEfY9Qvn1cUbbX1rX6z8N2/vtA3RoQvU71dYlP7jYfkzI/Hz/E7NV97VmQfNJWY89grY
	t3f32V8idXa5RZLHOjMCma0/dhnJ/JdZtv/sYf1o46le+W2vV1w+1RH8IVt64b6PFk9mvldi
	Kc5INNRiLipOBADcN7DGUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-06-24 17:35, Kamil Debski wrote:
> On Tue, Jun 24, 2014 at 1:54 PM, Kamil Debski <k.debski@samsung.com> 
> wrote:
>>> The Exynos4412 USB 2.0 PHY hardware differs from the description
>>> provided in the documentation. Some register bits have different
>>> function. This patch fixes the defines of register bits and changes
>>> the way how phys are powered on and off.
>> I guess this replaces the patch titled "drivers: phy: exynos4x12-phy:
>> fix HSIC1 power on/off sequence"
> Yes, indeed it replaces this patch. I did some more research on how the
> hardware actually behaves.

My patch was a quick hack to get HSIC1 working. Kamil spent much more time
trying to figure out how the hardware actually behaves. Please drop my patch
and replace it with this one.

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

>
>> Tested on ODROID-U2. Seems to be working as well as the previous patch:
> Thank you very much for testing.
>
>> - Internal SMSC hub works on boot and after reboot, tested with USB
>> mouse
>> - Internal SMSC ethernet device works on boot, but disappears upon
>> reboot. (same as previous patch, also reproduced by Marek)
> By reboot I guess that you mean typing "reboot" or by using SysRq magic
> and not power cycling?
>
> If so, I had experienced the same symptoms. I guess that the Ethernet
> chip is not reset properly and fails to enumerate without power cycling
> (it's nRESET pin is connected to P3V3).
>
> I found that removing regulator-always-on from buck8_reg: BUCK8 in the
> dts file fixes this problem.

Thanks for investigating this issue! I will add this fix to next version
of Odroid patches.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


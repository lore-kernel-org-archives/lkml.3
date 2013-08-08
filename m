Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915Ab3HHC5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:57:42 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:35569 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933812Ab3HHC5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <52029811.9080704@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
	<52028719.8070908@wwwdotorg.org>
	<CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com>
	<52029811.9080704@wwwdotorg.org>
Date: Thu, 8 Aug 2013 08:27:38 +0530
Message-ID: <CAKohpom658XKf5qPb3Wekb_uRfBEGHSxE=T06tEi30UTQ4K=Sg@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0 driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2013 00:25, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 12:06 PM, Viresh Kumar wrote:
>> On 7 August 2013 23:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>>>> cpufreq-cpu0 driver needs OPPs to be present in DT which can be probed by it to
>>>> get frequency table. This patch adds OPPs and clock-latency to tegra cpu0 node
>>>> for multiple SoCs.
>>>>
>>>> Voltage levels aren't used until now for tegra and so a flat value which would
>>>> eventually be ignored is used to represent voltage.
>>>
>>> This patch is problematic w.r.t. DT being an ABI.
>>
>> :(
>>
>>> We can certainly add new optional properties to a DT binding that enable
>>> new features. However, a new version of a binding can't require new
>>> properties to exist that didn't before, since that means that old DTs
>>> won't work with new kernels that require the new properties.
>>
>> To be honest I didn't get it completely. You meant operating-points
>> wasn't present before? Its here:
>>
>> Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
>> Documentation/devicetree/bindings/power/opp.txt
>>
>> Or you meant, Tegra never required voltage levels and we are getting
>> them in here.
>
> The current Tegra *.dts files do not contain this property. The current
> Tegra *.dts files must continue to work without modification in future
> kernels.

But that can't be true always.. Specially when we are moving things to
DT...

For example, we are moving your DMA driver to DT and hence in the
platform code, we are making a new DT node + removing static
platform device.

Now, old DT can't work with new kernel... That is just not possible.
That statement might be true for cases where we are just upgrading
existing DT support (but I doubt it there as well :) )..

>>> As such, I believe we do need some Tegra-specific piece of code that
>>> defines these OPP tables in the kernel, so that the operating-points
>>> property is not needed.
>>
>> Generic cpufreq driver depends on OPP library and so somebody has
>> to provide them. Now you can do it by calling opp_add() for each OPP
>> you have or otherwise.
>
> Sure. That's what the Tegra-specific cpufreq driver should do. It should
> be the top-level cpufreq driver. If parts of the code can be implemented
> by library functions or a core parameterizable driver, then presumably
> the Tegra driver would simply exist to provide those parameters and/or
> callback functions to the generic driver.

That would be something similar to what we are discussing on other
thread about new platform device...

You are asking me to go back to platform specific code instead of DT.
When there exists a generic enough way of providing this information
via DT, why should we put this in a driver?


>> Btw, you must have some specific voltage level for each freq, we can
>> get them here..
>
> Yes, I'm sure we do, but I have no idea what they are:-( It may even be
> board-specific or SoC-SKU-specific. I think we should defer this aspect
> for now.

Ok.

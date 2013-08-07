Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab3HGSG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:06:56 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:48874 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933001Ab3HGSGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <52028719.8070908@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
	<52028719.8070908@wwwdotorg.org>
Date: Wed, 7 Aug 2013 23:36:52 +0530
Message-ID: <CAKohpo=MpOyMGFTGeZWmoCRwmZ7+nQtP_yCGokPanEVYL0xbMw@mail.gmail.com>
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

On 7 August 2013 23:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 08:46 AM, Viresh Kumar wrote:
>> cpufreq-cpu0 driver needs OPPs to be present in DT which can be probed by it to
>> get frequency table. This patch adds OPPs and clock-latency to tegra cpu0 node
>> for multiple SoCs.
>>
>> Voltage levels aren't used until now for tegra and so a flat value which would
>> eventually be ignored is used to represent voltage.
>
> This patch is problematic w.r.t. DT being an ABI.

:(

> We can certainly add new optional properties to a DT binding that enable
> new features. However, a new version of a binding can't require new
> properties to exist that didn't before, since that means that old DTs
> won't work with new kernels that require the new properties.

To be honest I didn't get it completely. You meant operating-points
wasn't present before? Its here:

Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
Documentation/devicetree/bindings/power/opp.txt

Or you meant, Tegra never required voltage levels and we are getting
them in here.

> As such, I believe we do need some Tegra-specific piece of code that
> defines these OPP tables in the kernel, so that the operating-points
> property is not needed.

Generic cpufreq driver depends on OPP library and so somebody has
to provide them. Now you can do it by calling opp_add() for each OPP
you have or otherwise.

Btw, you must have some specific voltage level for each freq, we can
get them here..

> Similarly, we can't put invalid voltages into the DT, since if a later
> kernel version starts actually using that field, the HW will no longer
> work correctly. Unless perhaps we put 0 into the DT and make the binding
> define that 0 means "you can't change the voltage at all away from the
> boot value"?

Hmm.. so if you help me in getting actual voltage levels for these freqs
then this problem will be resolved. Otherwise I can check what will happen
if we pass zero to voltage.

> Is the operating-points property documented in
> Documentation/devicetree/bindings/ somewhere?

Check above.

> (Also Cc'ing the DT mailing list and maintainers)

Thanks.

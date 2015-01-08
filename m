Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbbAHEZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:25:12 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6534 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbAHEZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:25:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Jan 2015 20:17:47 -0800
Message-ID: <54AE06AE.8080603@nvidia.com>
Date: Thu, 8 Jan 2015 12:25:18 +0800
From: Vince Hsu <vinceh@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>, Lucas Stach <dev@lynxeye.de>,
        <swarren@wwwdotorg.org>, <gnurou@gmail.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <samuel.pitoiset@gmail.com>, <nouveau@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/11] ARM: tegra: add function to control the GPU rail
 clamp
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com> <1419331204-26679-2-git-send-email-vinceh@nvidia.com> <1419426990.2179.7.camel@lynxeye.de> <549B7638.2010405@nvidia.com> <20150105150932.GG12010@ulmo.nvidia.com> <20150107101900.GP10073@tbergstrom-lnx.Nvidia.com> <54AD0F37.5080609@nvidia.com> <20150107132709.GA6988@ulmo> <20150107140852.GR10073@tbergstrom-lnx.Nvidia.com> <20150107142828.GB7392@nvidia.com> <20150107144805.GF1621@ulmo>
In-Reply-To: <20150107144805.GF1621@ulmo>
X-Originating-IP: [10.19.108.126]
X-ClientProxiedBy: HKMAIL102.nvidia.com (10.18.16.11) To
 HKMAIL101.nvidia.com (10.18.16.10)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/07/2015 10:48 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jan 07, 2015 at 10:28:29PM +0800, Vince Hsu wrote:
>> On 04:08:52PM Jan 07, Peter De Schrijver wrote:
>>> On Wed, Jan 07, 2015 at 02:27:10PM +0100, Thierry Reding wrote:
>>>
>>>>> Yeah. I plan to have the information of all the clock client of the
>>>>> partitions and
>>>>> the memory clients be defined statically in c source, e.g. pmc-tegra124.c.
>>>>> All modules can declare which domain they belong to in DT. One domain can
>>>>> be really power gated only when no module is awake. Note the clock clients
>>>>> of
>>>>> one domain might not equal to the clocks of the module. The reset is not
>>>>> either.
>>>>> So I don't get the clock and reset from module. How do you think?
>>>> This whole situation is quite messy. The above sequence basically means
>>>> that drivers can't reset hardware modules because otherwise they might
>>>> race with the power domain code. It also means that we can't powergate
>>> The powerdomain framework won't call any powergating method as long as a
>>> module in the domain is still active. So as long as drivers don't try to
>>> reset the hw without having done a pm_runtime_get(), we shouldn't have such
>>> a race?
>> Agree. And as long as the driver has the correct reset procedure, that should
>> be fine to occur between power ungating and gating sequences.
>>
>>>> modules on demand because they might be in the same power domain as one
>>>> other module that's still busy.
>>>>
>>> The powerdomain framework keeps track of which modules are active (by hooking
>>> into runtime pm) and won't try to shutdown a domain unless all modules are
>>> inactive.
>> Yeah. By the way, that means we should start supporting runtime pm for all
>> the modules to use generic power domain.
> Indeed, that'll be a prerequisite before we can merge power domain
> support. I do have a couple of local patches that add very rudimentary
> runtime PM for various drivers. For starters we could probably just do
> the
>
> 	pm_runtime_enable(...);
> 	pm_runtime_get_sync(...)
>
> in the ->probe() and
>
> 	pm_runtime_put_sync(...);
> 	pm_runtime_disable(...);
>
> in the ->remove() callbacks for those drivers. That's by no means
> optimal but should get us pretty close to what we do now and still
> support the generic power domains.
Cool. Could you send me the patches?

Thanks,
Vince

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1


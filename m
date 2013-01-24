Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3AXFzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 00:55:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3AXFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 00:55:42 -0500
Message-ID: <5100CD0B.4080504@ti.com>
Date: Thu, 24 Jan 2013 11:26:27 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Olof Johansson <olof@lixom.net>, Hiroshi Doyu <hdoyu@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [v3 2/2] ARM: tegra: Skip scu_enable(scu_base) if not Cortex
 A9
References: <1358833924-24535-1-git-send-email-hdoyu@nvidia.com> <1358833924-24535-2-git-send-email-hdoyu@nvidia.com> <50FE2CA8.20100@ti.com> <50FEC503.2080602@wwwdotorg.org> <CAOesGMgtaCkiv285TU_vbAokN5M2MrANQ9piDcyXu5YMmbQq3A@mail.gmail.com> <50FFA620.50008@ti.com> <5100C0F7.9080101@wwwdotorg.org>
In-Reply-To: <5100C0F7.9080101@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Thursday 24 January 2013 10:34 AM, Stephen Warren wrote:
> On 01/23/2013 01:58 AM, Santosh Shilimkar wrote:
>> On Tuesday 22 January 2013 10:34 PM, Olof Johansson wrote:
>>> On Tue, Jan 22, 2013 at 8:57 AM, Stephen Warren
>>> <swarren@wwwdotorg.org> wrote:
>>>> On 01/21/2013 11:07 PM, Santosh Shilimkar wrote:
>>>>> On Tuesday 22 January 2013 11:22 AM, Hiroshi Doyu wrote:
>>>>>> Skip scu_enable(scu_base) if CPU is not Cortex A9 with SCU.
>>>>>>
>>>>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>>>>> ---
>>>>> Looks fine. I will also update OMAP code with the new
>>>>> interface. Thanks.
>>>>
>>>> OK, so patch 1/2 at least needs to get into a stable arm-soc branch
>>>> then. Unless there are violent objections, I'll forward patch 1/2 to
>>>> arm-soc and request it be added into a branch so that Tegra and OMAP can
>>>> both merge it into their branches as a dependency. I guess patch 2/2
>>>> could also be included; I don't think it has any complex dependencies
>>>> that'd prevent that, and would help to show how patch 1/2 gets used.
>>>>
>>>> Hiroshi, is this series the only dependency you need for your Tegra114
>>>> series? So, I could merge your Tegra114 series once this series is
>>>> applied?
>>>
>>> For something like this, it might make more sense for us to just apply
>>> the patches for OMAP on top, i.e. we'll pull the short branch from
>>> you, and then we can just apply patches (with maintainer acks) on top,
>>> instead of doing a bunch of single-patch pulls.
>>
>> In case you decide to apply patches, you can use patch in the end
>> of the email for OMAP. Attached the same in case mailer damages it.
>>
>> Btw, I noticed the build error with patch 1/1. Since I wasn't using
>> the first interface in OMAP code, I just bypassed it for testing.
>> I might be missing some dependent patch which added
>> read_cpuid_part_number().
>
> Thanks for the OMAP patch. I have pushed a couple of temporary and
> non-stable branches to:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
>
> Branch scu-base-rework contains just the SCU base address patches. After
> the few things listed below, I'll rename this branch and send a pull
> request to arm-soc.
>
> 1) Olof asked that Russell Ack or otherwise OK Hiroshi's latest versions
> of the following two patches since he commented on previous versions:
>
> ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
> ARM: Add API to detect SCU base address from CP15
>
> 2) Lorenzo's last comment on "ARM: tegra: Use DT /cpu node to detect
> number of CPU core" was:
>
> Please add missing punctuation, reword the commit log to make it clearer.
>
> ... so that patch needs a reworded commit log.
>
> 3) This branch needs testing on both Tegra30 and OMAP (I'm away from the
> office at the moment and can only test on Tegra20 here),
>
Tested 'scu-base-rework' branch on OMAP and it works just fine. I
noticed that the OMAP patch subject got line wrapped. Can you
please fix that before sending pull request ?
Thanks for picking up the patch.

Regards,
Santosh


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab3FGFSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:18:24 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:51896 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3FGFSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokgTmb6d79ipR9pV2iOfLSzngrPbMV3hFcuP64kbNYSQA@mail.gmail.com>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
	<027e8f1d4ac8de6351115f15a408431558510abb.1365079581.git.viresh.kumar@linaro.org>
	<CAKohpokGkZ9m0v1QaoXEv1m0mZqY70adWpXf3edQGmZnToRRcg@mail.gmail.com>
	<CAKohpokpiw3zS32oDL+T09ToOQxc28w=2R2up5T3h3c2Agc0wg@mail.gmail.com>
	<CAKohpo=SFauMyczEnxO_p_KQVQeznL+0V-FmLDtGmzL1Uv2iuA@mail.gmail.com>
	<CAKohponBfXsy21RTik+jWMukL_VnDNXOL7xmj4sEBF3HEBXqpQ@mail.gmail.com>
	<CAKohpo=DoWB+E-bgWCUVec5Y8wsfEu0V43Pg5mHzqep8yn0_JA@mail.gmail.com>
	<CAKohpokgTmb6d79ipR9pV2iOfLSzngrPbMV3hFcuP64kbNYSQA@mail.gmail.com>
Date: Fri, 7 Jun 2013 10:48:21 +0530
Message-ID: <CAKohpom=HvLwn7q9gicJXmHExoaDKKHcgQgT=1F0SKu3N3bXSg@mail.gmail.com>
Subject: Re: [PATCH 17/18] cpufreq: powerpc: move cpufreq driver to drivers/cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Robin Randhawa <robin.randhawa@arm.com>, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        deepthi@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2013 16:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 20 May 2013 10:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 13 May 2013 11:34, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> On 22 April 2013 12:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>> On 9 April 2013 14:05, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>>> On 5 April 2013 12:16, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>>>> On 4 April 2013 18:24, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>>>>> This patch moves cpufreq driver of powerpc platform to drivers/cpufreq.
>>>>>>>
>>>>>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>>>>> Cc: Paul Mackerras <paulus@samba.org>
>>>>>>> Cc: Olof Johansson <olof@lixom.net>
>>>>>>> Cc: linuxppc-dev@lists.ozlabs.org
>>>>>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>>>>>> ---
>>>>>>> Compile Tested only.
>>>>>>>
>>>>>>>  arch/powerpc/platforms/Kconfig                     | 31 ----------------------
>>>>>>>  arch/powerpc/platforms/pasemi/Makefile             |  1 -
>>>>>>>  arch/powerpc/platforms/powermac/Makefile           |  2 --
>>>>>>>  drivers/cpufreq/Kconfig.powerpc                    | 26 ++++++++++++++++++
>>>>>>>  drivers/cpufreq/Makefile                           |  3 +++
>>>>>>>  .../cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c  |  0
>>>>>>>  .../cpufreq/pmac32-cpufreq.c                       |  0
>>>>>>>  .../cpufreq/pmac64-cpufreq.c                       |  0
>>>>>>>  8 files changed, 29 insertions(+), 34 deletions(-)
>>>>>>>  rename arch/powerpc/platforms/pasemi/cpufreq.c => drivers/cpufreq/pasemi-cpufreq.c (100%)
>>>>>>>  rename arch/powerpc/platforms/powermac/cpufreq_32.c => drivers/cpufreq/pmac32-cpufreq.c (100%)
>>>>>>>  rename arch/powerpc/platforms/powermac/cpufreq_64.c => drivers/cpufreq/pmac64-cpufreq.c (100%)
>>>>>>
>>>>>> Hi Deepthi,
>>>>>>
>>>>>> Can you help testing this please?
>>>>>
>>>>> Ping!!
>>>>
>>>> Ping!!
>>>
>>> Hi Benjamin,
>>>
>>> Hope you are back from your vacations. Can you give it a try now?
>>
>> Ping!!
>
> Ping!!

Hi Rafael,

Its been more than 2 months now that this patch was first posted.
And the response from Maintainers isn't so great, irrespective of
how many times I pinged them.

This is what I think:
- It looked functionally correct to Benjamin but he wanted somebody
to actually test it.
- Arnd gave his Ack (So it looked functionally correct to him too)
- We can probably push this into linux-next now and see if somebody
complains of any breakage it has done. If not we can get it pushed for
3.11.

--
viresh

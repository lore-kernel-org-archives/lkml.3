Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbaEMNC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:02:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38451 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaEMNCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:02:55 -0400
Message-ID: <537217FA.1090200@arm.com>
Date: Tue, 13 May 2014 14:02:50 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>	<CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>	<CAPKp9uZbz3M1Xyu7SnSFEexzUPxPqFTSmd7zmU8jU5-Dwu4gvA@mail.gmail.com>	<CAKohpon9RLBPniYN+26Bk9GaMBAiTEFqp_YONzPBm7+3n17yiQ@mail.gmail.com> <CANuQgHHknAk4tS-3iGPP=OPobNBK_v=t86=T=A=UjJADPq_JVw@mail.gmail.com>
In-Reply-To: <CANuQgHHknAk4tS-3iGPP=OPobNBK_v=t86=T=A=UjJADPq_JVw@mail.gmail.com>
X-OriginalArrivalTime: 13 May 2014 13:03:00.0523 (UTC) FILETIME=[AB0CA7B0:01CF6EAB]
X-MC-Unique: 114051314025304601
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13/05/14 12:57, Chander Kashyap wrote:
> On 13 May 2014 16:35, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 13 May 2014 16:00, Sudeep Holla <sudeep.holla@arm.com> wrote:
>>> On Tue, May 13, 2014 at 9:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>> On 13 May 2014 13:11, [Chander Kashyap <chander.kashyap@linaro.org> wrote:
>>>>
>>>> What happened to your name ? "["
>>>>
>>>>> From: Chander Kashyap <k.chander@samsung.com>
>>>>>
>>>>> It may be possible to unregister and re-register the cpufreq driver.
>>>>> One such example is arm big-little IKS cpufreq driver. While
>>>>> re-registering the driver, same OPPs may get added again.
>>>>>
>>>>> This patch detects the duplicacy and discards them.
>>>>>
>>>>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>>>>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>>>>> ---
>>>>>   drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>>>>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>>>
>>>> I wouldn't say that this approach is particularly bad or wrong, but what
>>>> about this instead?
>>>>
>>>
>>> Yes I prefer this and this exactly what I had[1] in my OPP DT series which
>>> we could not conclude on the bindings. You also need patch[2] for DT version.
>>
>> Ahh, I have just reinvented the wheel. Though I can see now that I have
>> Acked those patches as well :)
>>
>> So, what are the plans for those patches then? As Chander also needs few
>> of those.
>>
>> Probably split the series to get the non-blockers upstream Atleast ?
>>
>> Another thing that I thought later, though the problem can be fixed by
>> your version of patches, the version from chander had something good as
>> well. It would get rid of duplicate entries coming from dtb. Would it make
>> sense to get that part in as well?
>
> This patch takes care for duplicate entries even without dt. Hence i
> feel it can go as separate patch.
>

Sorry if I added any confusion. My original patch series addressed both the
issues:

1. duplicate entries added by OPP library(same as addressed by your patch) and
2. another to avoid duplication in the devicetree for OPPs

IIUC Exynos don't use ST for OPPs(yet), so you need to address only (1).
But we still need (2) before any bL platforms use DT for OPPs and need CPUFreq 
support. And yes we can address this separately.

Regards,
Sudeep


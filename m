Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbaEML5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:57:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44335 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbaEML5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon9RLBPniYN+26Bk9GaMBAiTEFqp_YONzPBm7+3n17yiQ@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>
	<CAPKp9uZbz3M1Xyu7SnSFEexzUPxPqFTSmd7zmU8jU5-Dwu4gvA@mail.gmail.com>
	<CAKohpon9RLBPniYN+26Bk9GaMBAiTEFqp_YONzPBm7+3n17yiQ@mail.gmail.com>
Date: Tue, 13 May 2014 17:27:35 +0530
Message-ID: <CANuQgHHknAk4tS-3iGPP=OPobNBK_v=t86=T=A=UjJADPq_JVw@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>, Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 May 2014 16:35, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 13 May 2014 16:00, Sudeep Holla <sudeep.holla@arm.com> wrote:
>> On Tue, May 13, 2014 at 9:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> On 13 May 2014 13:11, [Chander Kashyap <chander.kashyap@linaro.org> wrote:
>>>
>>> What happened to your name ? "["
>>>
>>>> From: Chander Kashyap <k.chander@samsung.com>
>>>>
>>>> It may be possible to unregister and re-register the cpufreq driver.
>>>> One such example is arm big-little IKS cpufreq driver. While
>>>> re-registering the driver, same OPPs may get added again.
>>>>
>>>> This patch detects the duplicacy and discards them.
>>>>
>>>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>>>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>>>> ---
>>>>  drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>>>>  1 file changed, 19 insertions(+), 9 deletions(-)
>>>
>>> I wouldn't say that this approach is particularly bad or wrong, but what
>>> about this instead?
>>>
>>
>> Yes I prefer this and this exactly what I had[1] in my OPP DT series which
>> we could not conclude on the bindings. You also need patch[2] for DT version.
>
> Ahh, I have just reinvented the wheel. Though I can see now that I have
> Acked those patches as well :)
>
> So, what are the plans for those patches then? As Chander also needs few
> of those.
>
> Probably split the series to get the non-blockers upstream Atleast ?
>
> Another thing that I thought later, though the problem can be fixed by
> your version of patches, the version from chander had something good as
> well. It would get rid of duplicate entries coming from dtb. Would it make
> sense to get that part in as well?

This patch takes care for duplicate entries even without dt. Hence i
feel it can go as separate patch.


>
> --
> viresh



-- 
with warm regards,
Chander Kashyap

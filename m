Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbaEMLhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:37:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48153 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaEMLhf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:37:35 -0400
Message-ID: <537203F9.4000009@arm.com>
Date: Tue, 13 May 2014 12:37:29 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Nishanth Menon <nm@ti.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "[Chander Kashyap" <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>	<CAKohpo=6qXer+RRS-F6x=O1VLzbWq+_a-b29MaUzZBvt7XzDwQ@mail.gmail.com>	<CAPKp9uZbz3M1Xyu7SnSFEexzUPxPqFTSmd7zmU8jU5-Dwu4gvA@mail.gmail.com> <CAKohpon9RLBPniYN+26Bk9GaMBAiTEFqp_YONzPBm7+3n17yiQ@mail.gmail.com>
In-Reply-To: <CAKohpon9RLBPniYN+26Bk9GaMBAiTEFqp_YONzPBm7+3n17yiQ@mail.gmail.com>
X-OriginalArrivalTime: 13 May 2014 11:37:40.0034 (UTC) FILETIME=[BF000A20:01CF6E9F]
X-MC-Unique: 114051312373300501
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 13/05/14 12:05, Viresh Kumar wrote:
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
>>>>   drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>>>>   1 file changed, 19 insertions(+), 9 deletions(-)
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

Yes correct, it was stalled due to no discussions on the bindings.

> So, what are the plans for those patches then? As Chander also needs few
> of those.
>
> Probably split the series to get the non-blockers upstream Atleast ?
>

I can do that.

> Another thing that I thought later, though the problem can be fixed by
> your version of patches, the version from chander had something good as
> well. It would get rid of duplicate entries coming from dtb. Would it make
> sense to get that part in as well?
>

That requires agreement on the bindings. The main issue with shared opp
bindings is that in general we don't want to modify the standard bindings
without covering all aspects. It will avoid carrying around buggy bindings
forever as its ABI.

There was another thread from Samsung modifying bindings[0] and Rob insisted to
join the discussion[1] I started, but I never got any feedback.

Regards,
Sudeep

[0] http://marc.info/?l=devicetree&m=139152254008892&w=2
[1] http://www.spinics.net/lists/arm-kernel/msg303977.html


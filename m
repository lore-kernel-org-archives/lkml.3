Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbaCDOCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:02:32 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51610 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbaCDOCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:02:31 -0500
Message-ID: <5315DCF1.90608@gmail.com>
Date: Tue, 04 Mar 2014 15:02:25 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Jason Cooper <jason@lakedaemon.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
References: <20140207180836.GE8533@titan.lakedaemon.net> <1392667236-19126-1-git-send-email-jason@lakedaemon.net> <20140303150215.GI21483@n2100.arm.linux.org.uk> <20140303173740.GC16655@lunn.ch> <20140303181529.GM21483@n2100.arm.linux.org.uk> <20140303222406.GW1872@titan.lakedaemon.net> <20140304092616.GH16655@lunn.ch> <5315AD6F.1070804@gmail.com> <20140304121136.GR21483@n2100.arm.linux.org.uk> <20140304135306.GL1872@titan.lakedaemon.net>
In-Reply-To: <20140304135306.GL1872@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 02:53 PM, Jason Cooper wrote:
> On Tue, Mar 04, 2014 at 12:11:36PM +0000, Russell King - ARM Linux wrote:
>> On Tue, Mar 04, 2014 at 11:39:43AM +0100, Sebastian Hesselbarth wrote:
>>> On 03/04/2014 10:26 AM, Andrew Lunn wrote:
>>>>> I could have sworn this was discussed with this particular patchset, but
>>>>> I'm unable to find the conversation in my archives.  Neither during the
>>>>> patch submission process, nor the (long) pull request thread.
>>>>>
>>>>> Perhaps it was an irc conversation?  Andrew, Sebastian, can you find a
>>>>> link?  iirc, one of the DT maintainers (Mark Rutland?) raised the same
>>>>> concern and I thought we answered that sufficiently...
>>>>
>>>> It was the cpufreq driver which caused the discussion. I looked at it
>>>> for a while, and then task swapped onto the kirkwood move into
>>>> mach-mvebu.
>>>
>>> I guess you are looking for this discussion
>>>
>>> http://comments.gmane.org/gmane.linux.power-management.general/41053
>>>
>>> and specifically Mark's remarks on PMU and DT in here
>>>
>>> http://permalink.gmane.org/gmane.linux.ports.arm.kernel/285384
>>>
>>> BTW, +1 for a single PMU node that either serves an mfd (or type
>>> of) driver or that subsystem drivers derive their resources from.
>>> Looking at Dove FS, that would also include clock gating, which
>>> could be a mess to sort out.. anyway, let's get it on.
>>
>> So we have cpufreq, pm domains and an irq controller.  What's the plan
>> for this, who's going to look at sorting this out?
>
> Andrew, Sebastian?  I'm currently task-saturated...

Phew, looks like I'll have to take it?

Are you guys ok with having a single PMU node with syscon provided
regmap and make all drivers depend on it? I'd like to get a go from
Russell here, as he has clearly something in mind.

We can consolidate drivers later if required. If we start that now,
we definitely risk running out of time for v3.15.

Sebastian


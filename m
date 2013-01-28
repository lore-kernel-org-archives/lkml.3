Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3A1QhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:37:04 -0500
Received: from mx2.parallels.com ([64.131.90.16]:42214 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3A1QhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:37:02 -0500
Message-ID: <5106A941.6060403@parallels.com>
Date: Mon, 28 Jan 2013 20:37:21 +0400
From: Lord Glauber Costa of Sealand <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Michael Kerrisk <mtk@lwn.net>
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com> <51062AB5.9060203@parallels.com> <51062DA8.1060804@parallels.com> <87k3qxu3kp.fsf@xmission.com> <51063558.1010402@parallels.com> <87k3qxs2ko.fsf@xmission.com>
In-Reply-To: <87k3qxs2ko.fsf@xmission.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2013 08:19 PM, Eric W. Biederman wrote:
> Lord Glauber Costa of Sealand <glommer@parallels.com> writes:
> 
>> On 01/28/2013 12:14 PM, Eric W. Biederman wrote:
>>> Lord Glauber Costa of Sealand <glommer@parallels.com> writes:
>>>
>>>> I just saw in a later patch of yours that your concern here seems not
>>>> limited to backed ram by tmpfs, but with things like the internal
>>>> structures for userns , to avoid patterns in the form: 'for (;;)
>>>> unshare(...)'
>>>>
>>>> Humm, it does seem sensible. The kernel memory controller aims to
>>>> prevent exactly things like that. But they all exist already before
>>>> userns: there are destructive patterns like that with sockets, dentries,
>>>> processes, and pretty much every other resource in the kernel. So
>>>> Although the recommendation per-se makes sense, I am wondering if it is
>>>> worth it to mention anything in the user_ns config?
>>>
>>> The config might be overkill.  However I have already gotten bug reports
>>> about there being no limits.
>>>
>>> So someone needs to stop and connect the dots and say: 
>> Absolutely, and I am all for it
>>
>>> "If you care this is what you can do." 
>>
>> How about we say it, then?
>>
>> The current text in quite cryptic in this aspect, in the sense that it
>> doesn't give enough information for standard people about what are the
>> problems involved.
>>
>> Of course, maybe the Kconfig text is not the best place for having all
>> the info: but don't we have some place in Documentation/ where we could
>> put this, and then refer people there from Kconfig ?
> 
> At this point I have written the best text I can.
> 
> Please feel free to look at my tree at:
> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next
> 
Will do soon, thanks for your effort.

> and send me an patch on top of that to improve the wording.
> 
> At this point I have done my best to connect the dots for people who
> care, that the memory control group is what they need to limit what
> people can do with user namespaces.
> 
> My hope is that there is at least a passing mention in the next user
> namespace article on lwn.
It would definitely be helpful. Let's hope someone from there is reading! =)

> 
> For two pieces of software that were designed to complement each other
> I find it a bit surprising how many people (including myself) need the
> connection made that memory control groups and user namespaces should go
> together.

Well, I've manifested many times in here that I am less than satisfied
about the fact that the connection between namespaces and cgroups are so
loose. There are many situations, like virtualizing the proc files and
friends where I believe we could benefit from having the information
about whether or not cgroups and namespaces are used at the same time.

But since after considering a lot of alternatives, I could never come up
with one that were really clean,  I guess just communicating it
extensively is the best we can do so far.


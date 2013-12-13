Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3LMKXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:23:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35408 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3LMKXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:23:49 -0500
Message-ID: <52AADF96.4090602@oracle.com>
Date: Fri, 13 Dec 2013 11:21:10 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <20131213002523.GA20706@redhat.com> <20131213014220.GB11068@kroah.com> <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 06:09 AM, James Morris wrote:
> On Thu, 12 Dec 2013, Greg Kroah-Hartman wrote:
>
>> On Thu, Dec 12, 2013 at 07:25:23PM -0500, Dave Jones wrote:
>>> On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
>>>
>>>   > - who will keep adding these triggers going forward?
>>>
>
> I think we'd need to have someone commit to maintaining this long term
> before seriously considering it as part of mainline.  Over time it will
> become increasingly useless if new triggers aren't added.

Based on your input, we (the Ksplice team) will probably set up a public 
git repository where we maintain these patches on top of the latest 
released kernel.

> What happens when code is refactored, who refactors the triggers?
>
>>> also..
>>>
>>> - Who will test the existing triggers are doing the right thing when related code changes.
>>

I don't think refactoring or maintenance is a huge issue. The triggers 
are mostly one-liners in the error path of a specific input validation 
check.

I haven't maintained these patches for a very long time, but at least 
nothing came up in the six months of development that I've had these 
patches sitting for.

I'd say the person doing the refactoring should also take care to 
maintain the trigger, but if it just doesn't make sense anymore, it can 
also just be taken out.

In any case, maintaining a public git repository alongside mainline will 
give us some experience with overcoming refactoring/code changes.

>> And:
>>    - how do you determine an "expoit attempt" from "userspace program
>>      doing something stupid" / "corrupted filesytem mounted"?
>>
>
> Right, and if there are enough false positives, it'll end up being quite
> useless.
>
> I suspect this kind of thing is better done in userspace anti-malware
> scanning.
>
>> I really don't like this, it means that our normal error handling for
>> userspace data will suddenly all have CVE entries on them over time.
>> How is that helpful to anyone?
>>
>> Think ahead in 10-20 years, what is the code paths going to look like
>> then?  Horrible...
>
> Agree.
>
> This could make an interesting research project outside of the kernel. It
> doesn't belong in mainline without at least first being proven in the
> field and also properly maintained long term, if at all.
>

I already suggested a 5-year expiry date for any triggers we add. It's 
easy to retire them based on the CVE (or other) identifier that includes 
the year (possibly combined with git blame and friends).

I also think the set of triggers should be limited to serious bugs that 
could lead to privilege escalation. There are not THAT many of them. 
There are probably fewer than 20 every year, which would cap the total 
number of triggers at 100 in the whole kernel at any given time.

The point is NOT to add triggers in every error path in the kernel, of 
course not. Triggers should only be added where there's a real 
possibility of the bug actually being exploited. I thought about 
requiring a proof-of-concept exploit code to be provided with each 
trigger as well, but that could be too hard to be useful in practice, 
since actually exploiting any given potential privilege escalation bug 
could require a lot of ingenuity.

Thanks,


Vegard

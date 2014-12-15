Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbaLOTE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:04:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaLOTE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:04:57 -0500
Message-ID: <548F30D5.9020109@nod.at>
Date: Mon, 15 Dec 2014 20:04:53 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [GIT PULL] Staging driver patches for 3.19-rc1
References: <20141215175535.GA4665@kroah.com> <CAFLxGvwvj_ihWQQV3yY8Czxt0F2ieP=CRBrPMKqUatpjj9zdvQ@mail.gmail.com> <20141215183038.GA6120@kroah.com> <548F2A10.5070601@nod.at> <20141215184407.GB6761@kroah.com>
In-Reply-To: <20141215184407.GB6761@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2014 um 19:44 schrieb Greg KH:
> On Mon, Dec 15, 2014 at 07:36:00PM +0100, Richard Weinberger wrote:
>>
>> Am 15.12.2014 um 19:30 schrieb Greg KH:
>>> On Mon, Dec 15, 2014 at 07:23:35PM +0100, Richard Weinberger wrote:
>>>> On Mon, Dec 15, 2014 at 6:55 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>> The following changes since commit 009d0431c3914de64666bec0d350e54fdd59df6a:
>>>>>
>>>>>   Linux 3.18-rc7 (2014-11-30 16:42:27 -0800)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.19-rc1
>>>>>
>>>>> for you to fetch changes up to 17d2c6439be65777245914be354c5a97c76ad246:
>>>>>
>>>>>   Staging: slicoss: Fix long line issues in slicoss.c (2014-12-02 16:54:43 -0800)
>>>>>
>>>>> ----------------------------------------------------------------
>>>>> Staging patches for 3.19-rc1
>>>>>
>>>>> Here's the big staging tree pull request for 3.19-rc1.
>>>>>
>>>>> We continued to delete more lines than were added, always a good thing,
>>>>> but not at a huge rate this release, only about 70k lines removed
>>>>> overall mostly from removing the horrid bcm driver.
>>>>>
>>>>> Lots of normal staging driver cleanups and fixes all over the place,
>>>>> well over a thousand of them, the shortlog shows all the horrid details.
>>>>>
>>>>> The "contentious" thing here is the movement of the Android binder code
>>>>> out of staging into the "real" part of the kernel.  This is code that
>>>>> has been stable for a few years now and is working as-is in the tens of
>>>>> millions of devices with no issues.  Yes, the code is horrid, and the
>>>>> userspace api leaves a lot to be desired, but it's not going to change
>>>>> due to legacy issues that we have no control over.  Because so many
>>>>> devices and companies rely on this, and the code is stable, might as
>>>>> well promote it out of staging.
>>>>>
>>>>> This was all discussed at the Linux Plumbers conference, and everyone
>>>>> participating agreed that this was the best way forward.
>>>>>
>>>>> There is work happening to replace the binder code with something new
>>>>> that is happening right now, but I don't expect to see the results of
>>>>> that work for another year at the earliest.  If that ever happens, and
>>>>> Android switches over to it, I'll gladly remove this version
>>>>
>>>> I don't understand this kind of logic.
>>>> a) Binder is considered a piece of shite.
>>>
>>> A piece of "shite" that works for the domain it is in, and people rely
>>> on it.
>>
>> Using this argument we could merge every singe vendor tree too.
>> The crap they carry works for their domain too... ;-)
> 
> That's a false-argument, you know that.  This code falls into the
> "distros have been using it and it is proven to work" requirement that
> we have often made for new features.
> 
> Fact is, this is useful code, in this area.  In the domain it is used
> in, it works properly, and the abi is sufficient.  Yes, it's ugly in
> spaces, and insecure if used outside of Android, but that's ok for the
> users of the code.

Let's discuss this while having a few beers.
It is going to be philosophic.

>>>> b) Google is working on a (hopefully sane) replacement.
>>>
>>> I never said that Google was the one working on a replacement.
>>
>> Okay. Who is working on it?
> 
> Some other company, it's not my place to pre-announce projects, sorry.

Yeah, this is sad. :-\

>> Is there a change that Android will pick it up?
> 
> Yes.

So then wait until this happens and ignore binder.

>>>> Why moving it out of staging then? What is the benefit?
>>>> Keep it there for more 2-3 years and then remove it.
>>>
>>> Because code in staging either has to progress forward to be merged out
>>> of staging, or it gets deleted.  Just leaving it in staging for 2-4 more
>>> years doesn't mean anything different from moving it to
>>> drivers/android/, if I'm still maintaining it, right?  What it does say
>>> is that people rely on this thing, probably you do as well, so let's
>>> mark it as such.
>>>
>>>> If you move it now out of staging into the core kernel it will be considered ABI
>>>> and getting rid of it can be hard...
>>>
>>> It's already considered an "ABI" and removing it is hard, nothing has
>>> changed there.
>>
>> Since when is stuff in staging considered ABI?
> 
> Since a few hundred million devices use it and we have userspace code
> that relies on it and can't be changed?

It is news to me that these devices use a mainline kernel.

I'm well a aware of the fact that there are a lot of android devices out there.
But why moving binder into the core kernel?
What is the benefit?
Does Google even care?

Thanks,
//richard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaIXVuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:50:19 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39210 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaIXVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140924142632.7fe876ce1e743753581160a9@linux-foundation.org>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com> <20140924075206.GC5865@mwanda>
 <20140924143555.GJ28253@tassilo.jf.intel.com> <20140924154142.GG5865@mwanda>
 <CAFo99gbGoyf6GEt4ST_Q_WfYe39j+ke7t7XL6QZBYvMesMNZQg@mail.gmail.com> <20140924142632.7fe876ce1e743753581160a9@linux-foundation.org>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Wed, 24 Sep 2014 23:49:56 +0200
Message-ID: <CAFo99gY8PAxTAourZpRDBosX9qWiOq_fS1xOHPAzujOwEhfCFw@mail.gmail.com>
Subject: Re: [PATCH] lib: string.c: Added a funktion function strzcpy
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Andi Kleen <ak@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-24 23:26 GMT+02:00 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 24 Sep 2014 22:51:14 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> 2014-09-24 17:41 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
>> > On Wed, Sep 24, 2014 at 07:35:55AM -0700, Andi Kleen wrote:
>> >> On Wed, Sep 24, 2014 at 10:52:06AM +0300, Dan Carpenter wrote:
>> >> > On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
>> >> > > On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
>> >> > > > Added a function strzcpy which works the same as strncpy,
>> >> > > > but guaranteed to produce the trailing null character.
>> >> > >
>> >> > > Do we really need the bizarre strncpy padding semantics for anything?
>> >> > > Why not just use strlcpy?
>> >> >
>> >> > We do need the padding in many places to prevent information leaks.
>> >>
>> >> Like where?
>> >>
>> >
>> > You're asking what would break if we switched every strncpy() to
>> > strlcpy() but it's not an easy question to answer.
>> >
>> > I've looked a lot at information leaks, but strings are still a blind
>> > spot for my Smatch.  My check only looks at normal variables, arrays.
>> > Eventually I hope to fix this, of course.
>> >
>> > I did a git search and Rickard has added some examples, but there were
>> > definitely other places that rely strncpy() padding before.
>> >
>> > regards,
>> > dan carpenter
>>
>>
>> Hi
>>
>> If you want to see examples of this type of error, you can check the
>> patches I've done over the past two months.
>> So in linux-next
>>
>> git log --patch-with-stat
>>
>> And search for my email address.
>>
>> And there is also an approximately 20 more patches I waited to see if
>> I will be able to use a potential strzcpy  :-)
>
> I have to say, this email thread has been a good demonstration of the
> effects of incomplete changelogging :(
>
> How's about you try again and this time include a *full* explanation of
> why you believe the kernel needs strzcpy()?  Describe the problem,
> provide those examples, explain the proposed solution, etc.
>
> Also...  I misread the code - that implementation indeed zeroes out to
> the end of the destination.  I'm not sure that it does it very
> efficiently though - it repeatedly dereferences `src' just to obtain a
> null byte?  A second nulling loop would be clearer and perhaps faster.


Hi

Thought that I was still fairly clear, or that I just assumed that
everyone was more or less familiar with the problems between strncpy
strlcpy etc.
Did not think all that should be includerad in chang log.

But okay, will take a few days before I have time to do all that :-(

I can agree that the code does not look well optimized, but because it
is exactly the same code as the current strncpy I assumed that someone
made that choice already...?

My addition were only the:

if (dest != tmp)
   *--tmp = '\0';


Kind regards
Rickard Strandqvist

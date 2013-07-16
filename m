Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3GPPus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:50:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60363 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab3GPPuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:50:46 -0400
Message-ID: <51E56BD7.8080205@windriver.com>
Date: Tue, 16 Jul 2013 11:50:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg KH <greg@kroah.com>, <stable@vger.kernel.org>,
        <ksummit-2013-discuss@lists.linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
References: <1373916476.2748.69.camel@dabdike> <20130715201943.GA22131@roeck-us.net> <1373925868.24167.35.camel@shinybook.infradead.org> <20130715220730.GA23916@roeck-us.net> <51E479D0.4040304@zytor.com> <20130715232209.GB24650@roeck-us.net> <51E49036.5000901@zytor.com> <20130716002128.GA9278@kroah.com> <51E4930F.9030602@zytor.com>
In-Reply-To: <51E4930F.9030602@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-07-15 08:25 PM, H. Peter Anvin wrote:
> On 07/15/2013 05:21 PM, Greg KH wrote:
>>>
>>> However, it doesn't seem to happen too often, but it does underscore the
>>> need for a maintainer to be able to *retroactively* NAK a patch for
>>> stable, if it is uncovered that it isn't appropriate after all.
>>
>> I give maintainers 2 different chances to NAK a patch, and if they miss
>> those, I can also easily revert a patch that got applied and do a new
>> release, which I have done in the past.
>>
> 
> Yes, it doesn't actually seem to be a problem in practice.
> 
> In other words, the current system seems to work well, and unless
> someone wants to show cases where it doesn't work I don't see a reason
> to switch it...

I'd agree with that; I recently found something in 3.4.x that wasn't
quite right and Greg reverted it without hesitation.  I think that
instance could have been observed earlier in a semi-automated fashion
by adding a check to ensure the patched function(s) in the cherry
pick match the patched function in the original.  I had a hacked up
script to do this for my 2.6.34.x longterm commits:

http://git.kernel.org/cgit/linux/kernel/git/paulg/longterm-queue-2.6.34.git/tree/scripts/reviewbot

It might be worthwhile having some kind of similar thing looking
at the stable-queue.git content as it flows in?

Some additional possible points for discussion:

The risk of an incorrectly applied (or simply inappropriate use
of) a patch goes up exponentially with the size of the gap
between mainline where it appeared and the baseline of the
older target stable tree.

Meaning that commit in 3.10 will most likely seamlessly apply
to 3.9, but perhaps not so easy to 3.4, and it may not even
be appropriate for 3.0 at all.  Those are the worst ones to
detect; the commits which will happily "git am" but simply are
not appropriate because the baseline never had the bug/issue.

The patch creator and/or the maintainer are most likely the
best people who can comment on what versions a commit is
applicable to -- we have that now as a pseudo comment on
the Cc: stable line -- encouraging more active use of it
might be worthwhile?

Anyway, the effort for maintaining the older/longterm trees is
generally going to be more than for the "current minus one"
tree.  And if an increase in the strictness of what goes into
stable is made, it would have the most effect in terms of
making a stable maintainer's life easier there.

I guess what I'm driving at here, is that there is the option
to be more strict with the older releases vs. the "current-1"
release, and I wouldn't be surprised if the commit counts on
the various active stable branches reflect that Greg is already
implicitly doing this to some degree.

Maybe that opens discussion on longterm releases, such as how
many there should be, what they should contain, how long they
should live and so on?  To some degree, the answers to those
questions are largely at the mercy of the effort the maintainer
is willing to put in, but at the same time, having a certain
level of consistency and a uniform message to present to the
world about the different releases is good as well.

Paul.
--

> 
> 	-hpa
> 
> 
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbaJaUeF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:34:05 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:61127 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbaJaUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <1414786943.3014.37.camel@jlt4.sipsolutions.net>
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
 <1414741273.3014.3.camel@jlt4.sipsolutions.net> <20141031193408.GA12953@wotan.suse.de>
 <1414786943.3014.37.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 31 Oct 2014 13:33:40 -0700
X-Google-Sender-Auth: lZ5SvgKLlcqFNGewLCsm8EBHKBE
Message-ID: <CAB=NE6UVca47FyZv54pED3C_1go+-Ra_AbSwW1+=Gj5YWP0GHw@mail.gmail.com>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for CONFIG_BACKPORT
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 1:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2014-10-31 at 20:34 +0100, Luis R. Rodriguez wrote:
>
>> > Please make this a post-process step that runs on everything, including
>> > the backport stuff, rather than running only on the source and assuming
>> > the backport stuff already uses this convention.
>>
>> I want to but lets consider the amount of work to maintain the two
>> separate approaches, is it worth it?
>
> I don't see why it'd be maintaining two approaches? Right now we have
> scripting to replace CONFIG_ with CPTCFG_, so couldn't we just add more
> scripting to replace CPTCFG_ with CONFIG_BACKPORT_ ?

Hm, OK well let me give it a shot, at compilation time which approach
are we going to use? I don't like the idea of having two different
sets of naming approaching for packaging and integration, however I
can see how that might be useful for determining where some code might
come from or how backports was used, but other than that we would need
to pick if we're going to support the integration naming scheme also
for packaging as an option or just use CPTCFG for it. If the same
naming scheme is an option then that means we either have to test both
or leave one untested. This is why I ultimately would prefer we just
stick to one approach for both.

The fact that CPTCFG has same length as CONFIG really has no empirical
value, its just cosmetic, meanwhile I am however more concerned with
the above and I think its worth some serious consideration.

> That also makes me think of something else - we currently use BACKPORT_
> as a prefix for some of the other stuff under compat/Kconfig, and in
> fact rename some things (like CONFIG_BACKPORT_AVERAGE) so maybe also
> using CONFIG_BACKPORT_ here isn't a great idea? Might want to use
> something else, say CONFIG_BPT_ or so.

That's a good point, I take it that it does not matter which one we
pick for each, so long as its different? If so I think CONFIG_BACKPORT
is pretty clear for things we carry over like device drivers, but this
is just subjective and so long as we pick something I think it'll be
fine.

I do believe the harder thing to decide is the above possible
divergence thing and if we can agree on that I think the rest of the
series is not as controversial.

  Luis

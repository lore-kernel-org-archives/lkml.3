Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbaDJQ7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:59:48 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:58826 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934663AbaDJQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <s5heh15pr18.wl%tiwai@suse.de>
References: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
 <53451077.2030102@openwrt.org> <CAB=NE6UUN4vQd3SpsvO5tcgaYq3YXQeE0KtZGki7p7OnR=J4RA@mail.gmail.com>
 <20140409191225.GA10560@kroah.com> <CAB=NE6VqY8yXoYuE0o01vq86imY8EtqLdkPa4bGMvR3bTaj5KQ@mail.gmail.com>
 <20140409202224.GA12953@kroah.com> <CAB=NE6XY5++p7hJQpQdwrFNUcGbUsKpC+oJiZQciXNduo+8j8A@mail.gmail.com>
 <20140409210613.GA14392@kroah.com> <s5heh15pr18.wl%tiwai@suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 10 Apr 2014 09:59:24 -0700
X-Google-Sender-Auth: rheyJI5zgU2wdFTbLpdmdNSwr5c
Message-ID: <CAB=NE6VeNTFeGxKXpYunkU-W=JPLMpOnrehttvsqB+yXkdz5fg@mail.gmail.com>
Subject: Re: Bumping required kernels to 3.0 for Linux backports ?
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felix Fietkau <nbd@openwrt.org>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:44 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 9 Apr 2014 14:06:13 -0700,
> Greg Kroah-Hartman wrote:
>>
>> On Wed, Apr 09, 2014 at 01:52:29PM -0700, Luis R. Rodriguez wrote:
>> > On Wed, Apr 9, 2014 at 1:22 PM, Greg Kroah-Hartman
>> > <gregkh@linuxfoundation.org> wrote:
>> > > On Wed, Apr 09, 2014 at 01:01:23PM -0700, Luis R. Rodriguez wrote:
>> > >> On Wed, Apr 9, 2014 at 12:12 PM, Greg Kroah-Hartman
>> > >> <gregkh@linuxfoundation.org> wrote:
>> > >> > On Wed, Apr 09, 2014 at 11:28:55AM -0700, Luis R. Rodriguez wrote:
>> > >> >> On Wed, Apr 9, 2014 at 2:18 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> > >> >> > The oldest kernel in OpenWrt that we're still supporting with updates of
>> > >> >> > the backports tree is 3.3, so raising the minimum requirement to 3.0 is
>> > >> >> > completely fine with me.
>> > >> >>
>> > >> >> OK note that 3.3 is not listed on kernel.org as supported. I'm fine in
>> > >> >> carrying the stuff for those for now but ultimately it'd also be nice
>> > >> >> if we didn't even have to test the kernels in between which are not
>> > >> >> listed. This does however raise the question of how often a kernel in
>> > >> >> between a list of supported kernels gets picked up to be supported
>> > >> >> eventually. Greg, Jiri, do you happen to know what the likelyhood of
>> > >> >> that can be?
>> > >> >
>> > >> > I don't know of anything ever getting picked up after I have said it
>> > >> > would not be supported anymore.
>> > >>
>> > >> Great! How soon after a release do you mention whether or not it will
>> > >> be supported? Like say, 3.14, which was just released.
>> > >
>> > > I only mention it around the time that it would normally go end-of-life.
>> > >
>> > > For example, if 3.13 were to be a release that was going to be "long
>> > > term", I would only say something around the normal time I would be no
>> > > longer supporting it.  Like in 2-3 weeks from now.
>> > >
>> > > So for 3.14, I'll not say anything about that until 3.16-rc1 is out,
>> > > give or take a week or two.
>> > >
>> > >> Also, as of late are you aware any distribution picking an unsupported
>> > >> kernel for their next choice of kernel?
>> > >
>> > > Sure, lots do, as they don't line up with my release cycles (I only pick
>> > > 1 long term kernel to maintain each year).  Look at the Ubuntu releases
>> > > for examples of that.  Also openSUSE and Fedora (although Fedora does
>> > > rev their kernel pretty regularly) don't usually line up.  The
>> > > "enterprise" distros are different, but even then, they don't always
>> > > line up either (which is why Jiri is maintaining 3.12...)
>> > >
>> > > Hope this helps,
>> >
>> > It does! Unless I don't hear any complaints then given that some
>> > distributions might choose a kernel in between and given also your
>> > great documented story behind the gains on trying to steer folks
>> > together on the 'ol 2.6.32 [0] and this now being faded, I'll be
>> > bumping backports to only support >= 3.0 soon, but we'll include all
>> > the series from 3.0 up to the latest. That should shrink compile /
>> > test time / support time on backports to 1/2.
>>
>> Why 3.0?  That's not supported by anyone anymore for "new hardware", I'd
>> move to 3.2 if you could, as that's the Debian stable release that will
>> be maintained for quite some time yet:
>>       https://www.kernel.org/category/releases.html
>
> Well, the support for "new hardware" is what backports project itself
> does, isn't it?
>
> Besides, SLES11 is still supported, so yes, including 3.0.x would be
> helpful.

That's two stakeholders for 3.0 -- but nothing is voiced for anything
older than that. Today I will rip the older kernels into oblivion.
Thanks for all the feedback!

 Luis

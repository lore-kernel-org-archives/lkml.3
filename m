Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaKQWhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:37:38 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:32890 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaKQWhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:37:36 -0500
Date: Mon, 17 Nov 2014 14:37:30 -0800
From: josh@joshtriplett.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W.Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-man <linux-man@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141117223730.GA961@cloud>
References: <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
 <20141116034005.GC5507@thunk.org>
 <20141116045232.GB18880@thin>
 <20141117113734.396798e6@lxorguk.ukuu.org.uk>
 <CALCETrXi1qHyu4_U7cbROB74n461nBZ9R7=0kfhR8-VFAwOF1w@mail.gmail.com>
 <0b65fd07-48ea-483b-8fd5-fd84d0bff881@email.android.com>
 <CALCETrWXC5dMOXTTBOiq4Cv+yjqbA_UdmAN-TDmNAJUo+ABxtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWXC5dMOXTTBOiq4Cv+yjqbA_UdmAN-TDmNAJUo+ABxtg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 02:22:59PM -0800, Andy Lutomirski wrote:
> On Mon, Nov 17, 2014 at 2:11 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
> >
> >
> > On November 17, 2014 1:07:30 PM EST, Andy Lutomirski <luto@amacapital.net> wrote:
> >>On Nov 17, 2014 3:37 AM, "One Thousand Gnomes"
> >><gnomes@lxorguk.ukuu.org.uk> wrote:
> >>>
> >>> > optional), I can do that too.  The security model of "having a
> >>group
> >>> > gives you less privilege than not having it" seems crazy, but
> >>> > nonetheless I can see a couple of easy ways that we can avoid
> >>breaking
> >>>
> >>> It's an old pattern of use that makes complete sense in a traditional
> >>> Unix permission world because it's the only way to do "exclude
> >>{list}"
> >>> nicely. Our default IMHO shouldn't break this.
> >>>
> >>> > that pattern, no_new_privs being one of them.  I'd like to make
> >>sure
> >>> > that nobody sees any other real-world corner case that unprivileged
> >>> > setgroups would break.
> >>>
> >>> Barring the usual risk of people doing improper error checking I
> >>don't
> >>> see one immediately.
> >>>
> >>> For containers I think it actually makes sense that the sysctl can be
> >>> applied per container anyway.
> >>
> >>We'll probably need per container sysctls some day.
> >
> > We already have a mess of per network namespace sysctls,
> > as well as few for other namespaces.
> >
> > We have the infrastructure it is just a matter of using it for whatever purpose we need.
> >
> 
> A list of group id ranges that it's permissible to drop would do the
> trick, both for setgroups and for unshare.  The downside would be that
> users in those groups (i.e. everyone by default) would not be able to
> unshare their user ns.
> 
> Better ideas welcome.

Personally, I think that seems like more flexibility than necessary to
achieve the goal.  I think a sysctl turning group-dropping on and off
would suffice; systems that know they don't use groups to exclude
specific users can enable that sysctl.

- Josh Triplett

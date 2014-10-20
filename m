Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaJTVCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:02:07 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:43924 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbaJTVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:02:04 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 20 Oct 2014 14:01:55 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v5] init: Disable defaults if init= fails
Message-ID: <20141020210155.GD29486@jtriplet-mobl1>
References: <5c6381879bea68aebb13530442f1cf8a052be97f.1411958379.git.luto@amacapital.net>
 <542B4DA3.5080105@gmail.com>
 <542B519B.6010001@landley.net>
 <542B5E44.40303@gmail.com>
 <542B7200.6030902@landley.net>
 <CALCETrWr--A26UEv_7DeZa-Te1fTBDQgCdZt24n5LWkAnOa6jQ@mail.gmail.com>
 <20141001180510.GA28540@cloud>
 <CALCETrUK07j8+iQ8oSW70sgePxg_GJY3ASBBS+U9fvp_f2Rz5w@mail.gmail.com>
 <20141014140052.2f114c158ffe6cd953020f1c@linux-foundation.org>
 <CALCETrVg_rFmSCSnyztRtvANQLd9k_G+bU8FiQB_5O5ecUd99w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVg_rFmSCSnyztRtvANQLd9k_G+bU8FiQB_5O5ecUd99w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 01:14:54PM -0700, Andy Lutomirski wrote:
> On Tue, Oct 14, 2014 at 2:00 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 1 Oct 2014 11:13:14 -0700 Andy Lutomirski <luto@amacapital.net> wrote:
> >
> >> On Wed, Oct 1, 2014 at 11:05 AM,  <josh@joshtriplett.org> wrote:
> >> > On Tue, Sep 30, 2014 at 09:53:56PM -0700, Andy Lutomirski wrote:
> >> >> I significantly prefer default N.  Scripts that play with init= really
> >> >> don't want the fallback, and I can imagine contexts in which it could
> >> >> be a security problem.
> >> >
> >> > While I certainly would prefer the non-fallback behavior for init as
> >> > well, standard kernel practice has typically been to use "default y" for
> >> > previously built-in features that become configurable.  And I'd
> >> > certainly prefer a compile-time configuration option like this (even
> >> > with default y) over a "strictinit" kernel command-line option.
> >> >
> >>
> >> Fair enough.
> >>
> >> So: "default y" for a release or two, then switch the default?  Having
> >> default y will annoy virtme, though it's not the end of the world.
> >> Virtme is intended to work with more-or-less-normal kernels.
> >>
> >
> > Adding another Kconfig option is tiresome.  What was wrong with strictinit=?
> 
> Now that this thread has gotten absurdly wrong, any thoughts?
> 
> My preference order is:
> 
> 1. The patch as is.
> 2. The patch, minus the config option (i.e. making it unconditional).
> 3. Something else.

Agreed.

> I would very much prefer to get *something* merged.  The current
> behavior is problematic for scripted kernel boots that don't use
> initramfs.
> 
> I can be flexible on the something else.  One option would be to allow
> a whole list of commands in init=, but that has compatibility issues.
> Another would be adding an option like init_fallback=/bin/sh.  A third
> is the original strictinit mechanism.  I don't really like any of
> them, because they're all more complex.

I agree, particularly because they *add* more logic rather than
*removing* logic.  In this case, I think a Kconfig option makes sense,
because it controls additional behavior (the init fallback mechanism).

Plus, adding more code to control init fallback at runtime then means I
have more code to compile out to make the kernel smaller, so I'd end up
adding that Kconfig option anyway. :)

> IOW, the no-fallback behavior is easy to implement, easy to
> understand, and has extremely predictable behavior.  The fallback
> behavior is more user friendly if you consider having a chance of
> booting to something useful if you typo your init= option (but also a
> chance of booting to something actively undesirable).

Here's an alternative proposal: how about we change the default
*without* a Kconfig option, see if anyone screams, and if they do, we
add that code back in under a Kconfig option as in your current patch?

Would that make your Kconfig senses stop tingling, Andrew? :)

- Josh Triplett

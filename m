Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3GNFYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 01:24:46 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35406 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3GNFYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 01:24:44 -0400
Date: Sat, 13 Jul 2013 22:24:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130714052441.GA9042@roeck-us.net>
References: <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
 <20130713064801.GA1305@kroah.com>
 <20130713114211.GA3112@thunk.org>
 <20130713182717.GA16637@kroah.com>
 <20130714022219.GC3112@thunk.org>
 <20130714035128.GA10697@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130714035128.GA10697@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 08:51:28PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Jul 13, 2013 at 10:22:19PM -0400, Theodore Ts'o wrote:
> > On Sat, Jul 13, 2013 at 11:27:17AM -0700, Greg Kroah-Hartman wrote:
> > > Ugh, the conversation has degenerated now into parsing the meaning of
> > > specific words.  This is why lawyers have created whole vocabularies
> > > that are not used by "normal" people.  There's a very good reason why
> > > I'm not a lawyer, and this is one of them...
> > > 
> > > If I change the word "critical" to "real", would that make everyone
> > > happy here?
> > > 
> > > It comes down to the simple fact that for stable kernels I _want_ to
> > > take bugfixes that any user would hit.  In other words, something that a
> > > distro kernel would take.
> > 
> > Yes, but ***Linus*** has said he only wants critical fixes in his tree
> > after -rc4.  It seems pretty clear that what he wants post -rc4 and
> > what you want in the stable tree are different.
> > 
> > You can change the stable_kernel_tree to be "real" bugs, but if Linus
> > is still using "critical" as the standard for mainline post-rc4, then
> > those of us who are maintainers are stuck between a rock and a hard
> > place.
> 
> You are confusing the words "real" and "critical" perhaps.  I, and other

A typical classification of bugs might be
	critical: mission critical, no workaround, must be fixed prior to
		customer release
	severe (high): related to core functionality, must fix, but not
		necessarily in first release.
	moderate (medium): Bugs that do not affect any critical user
		functionality; typically has workaround
	minor (low): Bugs that do not interfere with core functionality
		and are just annoyances that may or may not ever be fixed
	cosmetic: misspellings

Such classifications are widely used in the industry. The term "affecting users"
might apply to all of those, and even a cosmetic bug is "real".

I don't think this is about confusion, but about classification. Clearly we
don't want patches for cosmetic or minor bugs in stable releases, but where
is the cut-off point ? That may be clear for you and some of the maintainers,
but for me and probably many other maintainers, "critical" has a well defined
meaning which neither includes severe nor moderate bugs as per the classification
above.

The term "real" is much more vague and left to interpretation. My cutoff
point would be around "moderate" - it does affect users, but it is not
critical functionality. What is yours ?

Guenter

> large subsystem maintainers, based on how they submit fixes to Linus and
> to stable, view the late -rc portion as time for fixes that affect users
> and other issues like that.  So far, it's worked out pretty well and we
> don't seem to be in disagreement with Linus's view of what is a valid
> late -rc fix based on recent kernel development cycles.
> 
> The issue now is, we have maintainers who aren't sending stuff to Linus
> at all in the late -rc cycle and are relying on me to pick up things
> that are obviously "real" and "critical" fixes after .0 is out for .1
> and .2 to resolve "real" issues.
> 
> You are not one of these people, so I don't understand why you are
> getting upset and think that you somehow need to change how you mark
> stuff for stable.
> 
> The powerpc and iscsi people on the other hand, they need to look out...
> 
> chill out please and go enjoy the rest of the weekend,
> 
> greg k-h
> 

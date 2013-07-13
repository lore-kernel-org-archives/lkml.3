Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3GMGsI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:48:08 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49587 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3GMGsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:48:03 -0400
Date: Fri, 12 Jul 2013 23:48:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713064801.GA1305@kroah.com>
References: <20130711214830.611455274@linuxfoundation.org>
 <20130711222935.GA11340@redhat.com>
 <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713063607.GI32054@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 08:36:07AM +0200, Willy Tarreau wrote:
> On Fri, Jul 12, 2013 at 11:22:23PM -0700, Greg Kroah-Hartman wrote:
> > > So probably we should incite patch contributors to add a specific
> > > tag such as "Fixes: 3.5 and later", so that non-important patches
> > > do not need the Cc:stable anymore, but users who experience an issue
> > > can easily spot them and ask for their inclusion.
> > 
> > Huh?  What's wrong with the existing way people mark stable patches to
> > go back to much older kernel versions?  Is that not working well enough
> > for you?
> > 
> > And if something "fixes" an issue, then I want it in stable, just like
> > Linus wants that in his tree.
> 
> It's the difference between "this is a fix" and "please backport this
> fix into stable". As we aid in this thread, cc:stable is a bit too much
> automatic and sometimes not appropriate (not important enough fixes).

No, I've never said that.

I _want_ fixes in stable trees, as they are being done to, obviously,
fix problems.  So does Linus, why wouldn't a fix for something that is
an issue for someone _not_ go into his tree after -rc4?

Ok, for some issues, they need some time to "bake" I can understand, but
that's the exception not the rule at all.

If a distro would pick a patch up to solve a problem for a user, and
that patch is in Linus's tree, there's almost no reason that shouldn't
also be in the stable trees.

My issue is that people are trying to get me to take stuff that is _not_
fixes (i.e. build errors that are impossible to hit, or \n additions to
debugging kernel messages, or pseudo-optimizations of functions).

The other larger issue is that people somehow are not willing to send
their valid fixes to Linus after -rc4, and they flood in during the -rc1
merge and people expect me to backport them all into .1 because they are
lazy.

Again, specific examples are the 7 powerpc patches that are over a month
old that were marked for the stable tree, yet didn't hit Linus's tree
until now.  I can dig up more examples if wanted, just look at the flood
that comes in for -rc1.

I _should_ be seeing more patches marked for stable showing up after
-rc3 then for -rc1.  As it is, I think there's something wrong with
maintainers relying on me to do their work for them too much, and it's
finally pushed me to start complaining and pushing back.

greg k-h

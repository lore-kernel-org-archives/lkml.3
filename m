Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3GMS1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:27:19 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40436 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3GMS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:27:17 -0400
Date: Sat, 13 Jul 2013 11:27:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [ 00/19] 3.10.1-stable review
Message-ID: <20130713182717.GA16637@kroah.com>
References: <20130711224455.GA17222@kroah.com>
 <20130712141530.GA3629@roeck-us.net>
 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
 <20130712173150.GA5534@roeck-us.net>
 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
 <20130712195051.GB32054@1wt.eu>
 <20130713062223.GA15155@kroah.com>
 <20130713063607.GI32054@1wt.eu>
 <20130713064801.GA1305@kroah.com>
 <20130713114211.GA3112@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130713114211.GA3112@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 07:42:11AM -0400, Theodore Ts'o wrote:
> On Fri, Jul 12, 2013 at 11:48:01PM -0700, Greg Kroah-Hartman wrote:
> > > It's the difference between "this is a fix" and "please backport this
> > > fix into stable". As we aid in this thread, cc:stable is a bit too much
> > > automatic and sometimes not appropriate (not important enough fixes).
> > 
> > No, I've never said that.
> 
> You've not said this, but Linus has.  Linus has pointed at the
> following words which are in stable_kernel_rules:
> 
>  - It must fix a problem that causes a build error (but not for things
>    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>    security issue, or some "oh, that's not good" issue.  In short, something
>    critical.                                             ^^^^^^^^^^^^^^^^^^^
>    ^^^^^^^^

Ugh, the conversation has degenerated now into parsing the meaning of
specific words.  This is why lawyers have created whole vocabularies
that are not used by "normal" people.  There's a very good reason why
I'm not a lawyer, and this is one of them...

If I change the word "critical" to "real", would that make everyone
happy here?

It comes down to the simple fact that for stable kernels I _want_ to
take bugfixes that any user would hit.  In other words, something that a
distro kernel would take.

And, I'll throw up the famous "I know it when I see it", definition of
what a valid fix is, to keep people from "word parsing" the exact way to
write it all down.

It's a grey area, which is good, let's keep it that way.

And again, that's not the real problem here.  The real problem is that
people are keeping valid "fixes" out of the .0 kernel for some odd
reason.

So here's what I'm going to do.  I'm going to go through all of my
pending stable patches in the next few days, discarding anything that
remotely "hints"[1] that it should have been pushed to Linus for .0.

Then I'll notify those maintainers, and make them resend the patches,
and explain _why_ they held off sending them, if they really want them
in the stable releases.

That should hopefully start to notify maintainers that they need to step
up and send stuff to Linus earlier, or they can justify why they didn't
send them at the time (which is fine, I know I think I have valid
reasons for why I didn't send some of my -stable patches in for the .0
release.)

I'll start digging through linux-next about -rc4 timeframe and watch for
stable tags to show up, and start pestering people about why they are
there and not in Linus's tree.

And then let's see what happens for 3.11.0, and the 3.12-rc1 merge
window.  If nothing's changed by then compared to this flood we got for
3.11-rc1, then we can revisit it then.

Yes, this is going to require more work on my behalf for the next few
months, but what else was I going to do with my summer, actually enjoy
the weather?...

Sound ok with everyone?

greg k-h

[1] A big hint is the date of the patch being a month or so before .0
    was released.  I'll point to the powerpc mess as an example of
    that...

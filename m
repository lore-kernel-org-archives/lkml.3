Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3GNXxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:53:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:57013 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3GNXw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:52:59 -0400
Message-ID: <1373845958.19894.320.camel@pasglop>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Mon, 15 Jul 2013 09:52:38 +1000
In-Reply-To: <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130711222935.GA11340@redhat.com> <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-12 at 10:50 -0700, Linus Torvalds wrote:
> You cut out the important part:
> 
>  - It must fix a problem that causes a build error (but not for things
>    marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
>    security issue, or some "oh, that's not good" issue.  In short, something
>    critical.
> 
> That list is not a "or" list, it's an "and" list - it needs to follow
> *all* the rules. The exception is the "New device IDs and quirks are
> also accepted", which maybe should be made more clearly separate.

So if I read this (and stable_kernel_rules.txt) correctly, that means that
for example, let's say, we find in RHEL66 or SLES42 (possibly following
a user report), for example, that PCI hotplug is broken with some category
of devices on some machines.

We do a fix, it's roughtly 4 or 5 lines, pretty self contained. We get it
into the distro.

That still doesn't qualify for stable right ? We have to start shooting at
every distro around separately or wait for users of those other distros
to also hit it ?

Where is the line when something "Doesn't work" (without crashing/oops'ing or
being a security issue) ?

My personal line so far has been to take it and send it to -stable if the
patch is simple enough and self contained (little risk of side effects).

But I can stop if that's indeed the accepted rule.

Cheers,
Ben.



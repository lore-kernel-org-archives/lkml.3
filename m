Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3GNWzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 18:55:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:51492 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab3GNWzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:55:08 -0400
Message-ID: <1373842493.19894.296.camel@pasglop>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 15 Jul 2013 08:54:53 +1000
In-Reply-To: <CA+5PVA6xk6dR51=b6EDHTbP8XGD=tmwbHz-+dW=1_8fofq47hw@mail.gmail.com>
References: <20130711214830.611455274@linuxfoundation.org>
	 <CA+5PVA6xk6dR51=b6EDHTbP8XGD=tmwbHz-+dW=1_8fofq47hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 18:14 -0400, Josh Boyer wrote:
>    Why are subsystem maintainers holding on to fixes that are
> >   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
> >   that I don't see until a -rc1 merge?  It's as if developers don't
> >   expect people to use a .0 release and are relying on me to get the
> >   fixes they have burried in their trees out to users.  

Let me guess, a lot of these are Power8 fixes ... This is a bit special
this time around... we introduced some of the support in 3.9 and added a
bunch in 3.10. We found bugs, it's brand new HW (not even final yet),
and nobody out there has access to it nor will for a little while
longer, so indeed nobody is going to use 3.10.0.

I've been pushing back on a lot of it as a maintainer (which is why a
lot of stuff ended up in 3.10 instead of 3.9), but granted probably not
enough this time around.

It's hard because the guys are getting a LOT of pressure in part because
of distro schedules.

As you are aware (and I mentioned in another email), some enterprise
distros impose a very specific schedule for stuff to go upstream, and if
that misses, well .... you are out of the game for years or lots of $ to
convince them otherwise. Additionally, one of them has brain damaged
rules about preserving kernel ABIs which prevents any significant
addition for the entire lifetime of the distro major release.

This is bad, this should not affect upstream in theory, but in practice
it does because if we don't get into the damn enterprise distro, the
whole exercise is pointless to begin with and we may as well not release
the machines and stop the Linux business altogether.

So I make compromises. I delay some stuff because it's really not ready,
and I take some because it affects things like thread_struct layout
which I know *WILL* break kABI and will be VERY hard to get back to the
distro later, fully expecting that various bits of fixes are going to
eventually trickle later on until it's ready for public consumption.

Ben.



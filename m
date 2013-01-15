Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3AOSe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:34:56 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51604 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3AOSey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:34:54 -0500
Date: Tue, 15 Jan 2013 18:41:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sedat.dilek@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fbdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: fb: Rework locking to fix lock ordering on takeover
Message-ID: <20130115184140.3c8fcdd2@pyramind.ukuu.org.uk>
In-Reply-To: <CA+icZUVJ5hbPJvV4LMFGgD3Sto5=EV=MO9nutYdJwkiRrmpNJQ@mail.gmail.com>
References: <CA+icZUVJ5hbPJvV4LMFGgD3Sto5=EV=MO9nutYdJwkiRrmpNJQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A disappeared/busy/not-answering maintainer is not an excuse for
> handling serious regressions (even here in this case there are fixes
> around),

It's *not* a regression - that's the horrible bit. If it was a regression
we'd just back the changes out, wait for (or switch) maintainer and be
happy a release later.

Its a piece of terrible design that is years old and a bug that is at
least two years old which caused random hangs on Fedora boxes during boot
up and so on for several releases. What has happened is Daniel's changes
made the bug *visible* as it's now lockdep splatted and can thus be
analyzed and worked upon.

We are pretty good at regression squashing because you can just rewind a
bit, and try again later. In this case rewinding the lockdep splat
simply turns it back into random silent hangs.

> Personally, I am still missing a mei-driver fix [2] and a libata-dev fix [3].
> Both issues are not new to the maintainers.
> Not sure if shouting louder is the best strategy here.

Really its a kernel summit question. IMHO we ought to have a policy
that anything of any relevance has *two* maintainers or more. That way
there is always someone to help pick a new maintainer if one drops out
and we are mostly not at the mercy of real world happenings. We also need
to be much more active in giving maintainers the boot if they vanish (and
having two maintainers will balance the effect nicely).

In practice I think most maintainers can offhand name the person they'd
pick to replace them, so they can pretty easily switch to two maintainers.

> It would be great to have a place like a "board of arbitration" where
> someone can send blames.

There is a ton of stuff in bugzilla including fixes for some years old
stuff (eg bluetooth on some dongle types that broke in 2.6.3x). It's not
a case of inventing bodies to handle stuff, it's a case of two things

- people getting off their backsides to fix it
- enabling those people to get the job done

Finger pointing statistics and shame lists such as Rafael did are just
tools to help. At the end of the day its about people doing stuff.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3GOBkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 21:40:23 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:39021 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3GOBkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 21:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <1373845958.19894.320.camel@pasglop>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130711222935.GA11340@redhat.com>
	<20130711224455.GA17222@kroah.com>
	<20130712141530.GA3629@roeck-us.net>
	<CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	<20130712173150.GA5534@roeck-us.net>
	<CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	<1373845958.19894.320.camel@pasglop>
Date: Sun, 14 Jul 2013 18:40:20 -0700
X-Google-Sender-Auth: Xzkn7GcUx5QUrccsGupuF-Jk7rM
Message-ID: <CA+55aFx7Lax+m6wvPyfu_Om2aL-gYBEmfcrEqiC_nqCm1pwW6Q@mail.gmail.com>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 4:52 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> So if I read this (and stable_kernel_rules.txt) correctly, that means that
> for example, let's say, we find in RHEL66 or SLES42 (possibly following
> a user report), for example, that PCI hotplug is broken with some category
> of devices on some machines.
>
> We do a fix, it's roughtly 4 or 5 lines, pretty self contained. We get it
> into the distro.
>
> That still doesn't qualify for stable right ?

Not before it's been in the distro, no. Something like a PCI change
*definitely* should never be marked for stable, unless it causes
crashes or is a _new_ regression that causes dead machines.

Because the likelihood that that 4-5 line "obvious" change breaks
things is pretty high. It needs testing elsewhere - on the machines
that weren't broken - in a big way first.

And don't bother talking about "obvious fix". Especially not when it
comes to the PCI code.

                 Linus

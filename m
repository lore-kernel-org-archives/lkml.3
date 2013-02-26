Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3BZEoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:44:01 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44438 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3BZEoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130226042338.GA30944@srcf.ucam.org>
References: <18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226033156.GA24999@kroah.com>
	<20130226033803.GA30285@srcf.ucam.org>
	<20130226035416.GA1128@kroah.com>
	<20130226040456.GA30717@srcf.ucam.org>
	<20130226041324.GA7241@kroah.com>
	<20130226042338.GA30944@srcf.ucam.org>
Date: Mon, 25 Feb 2013 20:43:59 -0800
X-Google-Sender-Auth: kZhXwicT-qLF_h_5L6RMeWJ6OxM
Message-ID: <CA+55aFx9HkRGfMx6pfR2xsTf0vof_yyrT4ks5TzMKoEpS7w=5g@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 8:23 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> If the user has explicitly enrolled a hash then they're stepping outside
> the trust model.

This is the kind of totally bogus crap that no sane person should ever
spout. Stop it.

If the user has explicitly enrolled a hash, then that should be the
*primary* trust model, dammit. That should be very much what you
should care about first and foremost, and that should be your goal in
life. That's when the user says "I'm in control of my own machine, and
I want to trust *this*".

It's not about "stepping outside of the trust model". Quite the
reverse. It's about actually being *part* of the trust model, and
taking control of your own machine. It's the *good* scenario. It's
what you should encourage users to do.

No, it likely can't be the default because we shouldn't expect users
to care enough, but on the other hand the default should definitely
*not* be "enable random third party modules signed indirectly by MS",
which is what your crazy world-view seems to be.

So the first order should be: "we provide modules to cover all normal
users". You use the RH key for that.

The *second* order should be: "we encourage and tell people how to add
their own keys and sign modules they trust".

The third order should probably be "we encourage people to use random
one-time keys - probably with UEFI key checking turned off entirely,
because let's face it, that doesn't really add any real security for
most people". It's what kernel developers and most servers would
probably want to use. They likely don't do the whole UEFI crap anyway,
and random one-time keys are actually better against things like
rootkits etc than *any* centrally administered chain of trust.

Only somewhere really really deep down should the "ok, what about a MS
signature" thing be. It could be part of the user-level application
(part of your distribution) that displays the "are you really sure you
want to load this module with an unrecognized signature? I can tell
that it has a MS signature on it". But by the time you get this far,
you've already failed the first few normal levels.

            Linus

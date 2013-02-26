Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3BZEbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:31:13 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:36016 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab3BZEbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:31:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130226034842.GD30285@srcf.ucam.org>
References: <18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226032508.GA12906@thunk.org>
	<20130226032839.GA30164@srcf.ucam.org>
	<CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
	<20130226034250.GB30285@srcf.ucam.org>
	<CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
	<20130226034842.GD30285@srcf.ucam.org>
Date: Mon, 25 Feb 2013 20:31:08 -0800
X-Google-Sender-Auth: VNh1QTc8lgTS8EKTuR42ed8aoG8
Message-ID: <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 7:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
> Our users want to be able to boot Linux. If Microsoft blacklist a
> distribution's bootloader, that user isn't going to be able to boot
> Linux any more. How does that benefit our users?

How does bringing up an unlikely and bogus scenario - and when people
call you on it, just double down on it - help users?

Stop the fear mongering already.

So here's what I would suggest, and it is based on REAL SECURITY and
on PUTTING THE USER FIRST instead of your continual "let's please
microsoft by doing idiotic crap" approach.

So instead of pleasing microsoft, try to see how we can add real security:

 - a distro should sign its own modules AND NOTHING ELSE by default.
And it damn well shouldn't allow any other modules to be loaded at all
by default, because why the f*ck should it? And what the hell should a
microsoft signature have to do with *anything*?

 - before loading any third-party module, you'd better make sure you
ask the user for permission. On the console. Not using keys. Nothing
like that. Keys will be compromised. Try to limit the damage, but more
importantly, let the user be in control.

 - encourage things like per-host random keys - with the stupid UEFI
checks disabled entirely if required. They are almost certainly going
to be *more* secure than depending on some crazy root of trust based
on a big company, with key signing authorities that trust anybody with
a credit card. Try to teach people about things like that instead.
Encourage people to do their own (random) keys, and adding those to
their UEFI setups (or not: the whole UEFI thing is more about control
than security), and strive to do things like one-time signing with the
private key thrown out entirely. IOW try to encourage *that* kind of
"we made sure to ask the user very explicitly with big warnings and
create his own key for that particular module" security. Real
security, not "we control the user" security.

Sure, users will screw that up too. They'll want to load crazy nvidia
binary modules etc crap. But make it *their* decision, and under
*their* control, instead of trying to tell the world about how this
should be blessed by Microsoft.

Because it really shouldn't be about MS blessings, it should be about
the *user* blessing kernel modules.

Quite frankly, *you* are what he key-hating crazies were afraid of.
You peddle the "control, not security" crap-ware. The whole "MS owns
your machine" is *exactly* the wrong way to use keys.

                 Linus

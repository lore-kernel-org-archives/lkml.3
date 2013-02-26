Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3BZE55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 23:57:57 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58248 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3BZE5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 23:57:55 -0500
Date: Tue, 26 Feb 2013 04:57:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Florian Weimer <fw@deneb.enyo.de>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Message-ID: <20130226045747.GA31181@srcf.ucam.org>
References: <20130226023332.GA29282@srcf.ucam.org>
 <20130226030249.GB23834@kroah.com>
 <20130226031338.GA29784@srcf.ucam.org>
 <20130226032508.GA12906@thunk.org>
 <20130226032839.GA30164@srcf.ucam.org>
 <CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
 <20130226034250.GB30285@srcf.ucam.org>
 <CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
 <20130226034842.GD30285@srcf.ucam.org>
 <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:31:08PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 7:48 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > Our users want to be able to boot Linux. If Microsoft blacklist a
> > distribution's bootloader, that user isn't going to be able to boot
> > Linux any more. How does that benefit our users?
> 
> How does bringing up an unlikely and bogus scenario - and when people
> call you on it, just double down on it - help users?

What's unlikely or bogus about it? There's incentive to breach the 
Secure Boot trust model, and to do that you need signed code that'll run 
unsigned code in ring 0. Why would the black hats bother finding more 
subtle exploits if they can just write a new kexec loader?

>  - a distro should sign its own modules AND NOTHING ELSE by default.
> And it damn well shouldn't allow any other modules to be loaded at all
> by default, because why the f*ck should it? And what the hell should a
> microsoft signature have to do with *anything*?

So far? Nothing.

>  - before loading any third-party module, you'd better make sure you
> ask the user for permission. On the console. Not using keys. Nothing
> like that. Keys will be compromised. Try to limit the damage, but more
> importantly, let the user be in control.

So some sort of blocking insmod that waits for a sysrq input? I spent 
some time thinking about that, but then there's people who want 
automated installs on systems with bizarre storage hardware that depends 
on out of tree drivers. Like I said, *I'm* absolutely fine with not 
supporting out of tree drivers at all.

>  - encourage things like per-host random keys - with the stupid UEFI
> checks disabled entirely if required. They are almost certainly going
> to be *more* secure than depending on some crazy root of trust based
> on a big company, with key signing authorities that trust anybody with
> a credit card. Try to teach people about things like that instead.
> Encourage people to do their own (random) keys, and adding those to
> their UEFI setups (or not: the whole UEFI thing is more about control
> than security), and strive to do things like one-time signing with the
> private key thrown out entirely. IOW try to encourage *that* kind of
> "we made sure to ask the user very explicitly with big warnings and
> create his own key for that particular module" security. Real
> security, not "we control the user" security.

Yes, ideally people will engage in self-signing and distributions will 
have mechanisms for dealing with that.

> Sure, users will screw that up too. They'll want to load crazy nvidia
> binary modules etc crap. But make it *their* decision, and under
> *their* control, instead of trying to tell the world about how this
> should be blessed by Microsoft.

We can block third party modules by default, but they'll still be 
trusting Microsoft by default.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

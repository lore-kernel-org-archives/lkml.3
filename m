Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3IHQP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:15:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3IHQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:15:56 -0400
Date: Sun, 8 Sep 2013 09:18:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Message-ID: <20130908161859.GA18946@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
 <20130908064027.GA3587@kroah.com>
 <1378622648.2300.4.camel@x230>
 <20130908072408.GA5092@kroah.com>
 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 08:51:27AM -0700, Kees Cook wrote:
> On Sun, Sep 8, 2013 at 12:24 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sun, Sep 08, 2013 at 06:44:08AM +0000, Matthew Garrett wrote:
> >> On Sat, 2013-09-07 at 23:40 -0700, Greg KH wrote:
> >> > If you apply this, you break everyone who is currently relying on kexec
> >> > (i.e. kdump, bootloaders, etc.), from using signed kernel modules, which
> >> > personally, seems like a very bad idea.
> >>
> >> Enforcing signed modules provides you with no additional security if you
> >> have kexec enabled. It's better to make that obvious.
> >
> > Then document the heck out of it, don't disable a valid use case just
> > because it possibly could be used in some way that is different from the
> > original system.
> >
> > If you take this to an extreme, kexec shouldn't be here at all, as it
> > can do anything in the kernel wherever it wants to.
> >
> > kexec has nothing to do with signed modules, don't tie them together.
> 
> It's not accurate to say it has "nothing to do" with signed modules.
> The purpose of signed modules is to ensure the integrity of the
> running system against the root user.

For one type of thing, modules, not for all types of ways a root user
could do "bad" things.

If you want to create a flag/option for "don't trust a privileged root
user", great, I have no objection to that.

I do object to changing the functionality of random other options based
on the state of signed kernel modules being enabled or not.

> It was, however, incomplete. Terrible analogy follows: signed modules
> was locking the front door, but we have all sorts of windows still
> open. This closes those windows. You're trying to say that shutting
> windows has nothing to do with lumber locks. While technically true,
> this is about the intent of the barriers.

Then be specific about the intent and don't say that "if we lock the
front door with our key, suddenly all of the windows close and lock
automatically".  I wanted fresh air in some of those windows for various
reasons.  Provide a "lock this house completely down" option that does
this instead, don't overload an already usable option to do more than it
was supposed to do.

That way people can pick and choose the security they want, based on
their specific situation and systems.

> Anyone currently using signed modules (with sig_enforce) AND kexec is
> deluding themselves about what the state of their system's ring-0
> security stance is. Those people should be running without
> sig_enforce, and if they want both sig_enforce and kexec, then I would
> expect a follow-up patch from them to provide signed kexec support.

I want both, but I don't need signed kexec support because I want to use
kexec for a program that I "know" is correct because I validated the
disk image it was on before I mounted it.  We already have other ways to
"verify" things without having to add individual verification of
specific pieces.

Just like ChromeOS was "trusting" kernel modules on partitions that it
"knew" were ok because they were verified before mounting.  You didn't
need signed kernel modules to be able to create your own chain-of-trust
any more than we need to provide signed kexec for some people to be able
to trust the binary they are going to kexec.

Not to say that signed kexec support isn't a good idea, I'm all for
that, but it's a tangential issue here.

thanks,

greg k-h

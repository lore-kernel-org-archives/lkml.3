Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3IHRL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:11:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57354 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752572Ab3IHRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:11:27 -0400
Message-ID: <1378660284.2429.11.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Date: Sun, 08 Sep 2013 10:11:24 -0700
In-Reply-To: <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
	 <20130908064027.GA3587@kroah.com> <1378622648.2300.4.camel@x230>
	 <20130908072408.GA5092@kroah.com>
	 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-08 at 08:51 -0700, Kees Cook wrote:
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

That's not true if you look at the use cases.  Distros use signed
modules to taint the kernel:  insert an unsigned one and the kernel
taints; insert a properly signed one and it doesn't.  They use it for
support to tell if you've been adhering to your contract.  That use case
has nothing to do with security.

> It was, however, incomplete. Terrible analogy follows: signed modules
> was locking the front door, but we have all sorts of windows still
> open. This closes those windows. You're trying to say that shutting
> windows has nothing to do with lumber locks. While technically true,
> this is about the intent of the barriers.
> 
> Anyone currently using signed modules (with sig_enforce) AND kexec is
> deluding themselves about what the state of their system's ring-0
> security stance is. Those people should be running without
> sig_enforce, and if they want both sig_enforce and kexec, then I would
> expect a follow-up patch from them to provide signed kexec support.

The analogy is rubbish.  I can give away CAP_SYS_MODULE and enforce what
modules those I've given the permission to can insert by signing them.
I keep CAP_SYS_BOOT, so they can't use kexec to subvert this.

Your analogy seems to be giving away the whole root and then crying Dr
it hurts when I do this ...

James



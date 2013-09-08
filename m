Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3IHQgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 12:36:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3IHQgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 12:36:22 -0400
Date: Sun, 8 Sep 2013 09:39:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 08/11] kexec: Disable at runtime if the kernel
 enforces module loading restrictions
Message-ID: <20130908163926.GA19665@kroah.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
 <1378252218-18798-9-git-send-email-matthew.garrett@nebula.com>
 <20130908064027.GA3587@kroah.com>
 <1378622648.2300.4.camel@x230>
 <20130908072408.GA5092@kroah.com>
 <CAGXu5jLwCt6RtQC+kxcUC69tMydx8DO2QWDv3jK6_mOyT_iNbA@mail.gmail.com>
 <20130908161859.GA18946@kroah.com>
 <1378657487.2300.10.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378657487.2300.10.camel@x230>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 04:24:47PM +0000, Matthew Garrett wrote:
> On Sun, 2013-09-08 at 09:18 -0700, Greg KH wrote:
> 
> > I want both, but I don't need signed kexec support because I want to use
> > kexec for a program that I "know" is correct because I validated the
> > disk image it was on before I mounted it.  We already have other ways to
> > "verify" things without having to add individual verification of
> > specific pieces.
> 
> The kernel has no way to know that your kexec payload is coming from a
> verified image. It'll just as happily take something from an unverified
> image. If you've ensured that there's no way an attacker can call
> kexec_load() on an unverified image, then you don't need signed modules.

But I want, for other reasons (i.e. safety in layers), signed kernel
modules.  I also might actually want some debugfs files in some random
driver (like this series removes).

The point is that having a "lockdown" mode is good, I'm not disagreeing
there.  Just don't force it on people if they don't want it.  Allow them
to pick "lock everything down", or "I want signed modules", or "I don't
want kexec".

Don't lump all of this together such that people can not make that
choice between different things, because some people (i.e. me
specifically), do want them.

Heck, look at Red Hat.  They have been shipping signed kernel modules
for _years_ and yet they do not disable kexec.  Have they been "doing it
wrong" all of this time?   Perhaps people want signed modules just for
support reasons, not "security" reasons.

Don't take away those options.

thanks,

greg k-h

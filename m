Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3AaFiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:38:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:50866 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3AaFiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:38:06 -0500
Date: Thu, 31 Jan 2013 06:40:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130131054002.GA3697@kroah.com>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
 <20130130215211.GA28418@flint.arm.linux.org.uk>
 <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
 <20130130221946.GA14801@flint.arm.linux.org.uk>
 <CA+55aFyRHK3dmwQf_mdfB18dmoaRZqBG9FvHRqTs7cqBjgUs+g@mail.gmail.com>
 <CAPM=9tz6YBh2o3T8Ogt4K=wxSrC3Jc4PCJMzfpbyY=B132fA5g@mail.gmail.com>
 <20130131001339.GC14801@flint.arm.linux.org.uk>
 <CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfeXWAiXV18qGgOk9+2HHiD7LUuyk55brHFXd+_c6eZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 11:26:53AM +1100, Linus Torvalds wrote:
> On Thu, Jan 31, 2013 at 11:13 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> >
> > Which may or may not be a good thing depending how you look at it; it
> > means that once your kernel blanks, you get a lockdep dump.  At that
> > point you lose lockdep checking for everything else because lockdep
> > disables itself after the first dump.
> 
> Fair enough, we may want to revert the lockdep checking for
> console_lock, and make re-enabling it part of the patch-series that
> fixes the locking.
> 
> Daniel/Dave? Does that sound reasonable?

Reverting the patch is fine with me.  Just let me know so I can queue it
up again for 3.9.

thanks,

greg k-h

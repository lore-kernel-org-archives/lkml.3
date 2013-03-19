Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab3CSADw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:03:52 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:45921 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3CSADu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:03:50 -0400
Date: Mon, 18 Mar 2013 17:05:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 28/44] tty: Remove ldsem recursion support
Message-ID: <20130319000505.GA6516@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-29-git-send-email-peter@hurleysoftware.com>
 <20130318235940.GB5320@kroah.com>
 <1363651261.4568.3.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363651261.4568.3.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:01:01PM -0400, Peter Hurley wrote:
> On Mon, 2013-03-18 at 16:59 -0700, Greg Kroah-Hartman wrote:
> > On Mon, Mar 11, 2013 at 04:44:48PM -0400, Peter Hurley wrote:
> > > Read lock recursion is no longer required for ldisc references;
> > > remove mechanism.
> > > 
> > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > > ---
> > >  drivers/tty/tty_ldsem.c   | 83 +++++------------------------------------------
> > >  include/linux/tty_ldisc.h |  2 --
> > >  2 files changed, 8 insertions(+), 77 deletions(-)
> > 
> > Wait, why did you add something 3 patches ago, only to remove it here?
> > Why not just smush these patches together in the first place?
> 
> >From [PATCH v5 00/44] ldisc patchset...
> 
> On Mon, 2013-03-11 at 16:44 -0400, Peter Hurley wrote: 
> > v5 changes:
> > 
> > After completing an audit of the recursive use of ldisc
> > references, I discovered the _blocking_ recursive acquisition
> > of ldisc references was limited to line disciplines misusing
> > the tty_perform_flush() function.
> > With that now resolved in,
> >   'tty: Fix recursive deadlock in tty_perform_flush()'
> > the recursion design in ldsem has been removed.
> > 
> > The recursion removal is in its own patch,
> >   'tty: Remove ldsem recursion support'
> > to ease review for those that have already reviewed the
> > ldsem implementation.

Ah, ok.  Who reviewed the ldsem implementation?  I didn't see any other
acks on it, or did I miss them?

thanks,

greg k-h

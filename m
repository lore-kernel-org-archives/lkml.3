Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3CSAMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:12:23 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:36691 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3CSAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:12:22 -0400
Message-ID: <1363651923.4568.11.camel@thor.lan>
Subject: Re: [PATCH v5 28/44] tty: Remove ldsem recursion support
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Date: Mon, 18 Mar 2013 20:12:03 -0400
In-Reply-To: <20130319000505.GA6516@kroah.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
	 <1363034704-28036-29-git-send-email-peter@hurleysoftware.com>
	 <20130318235940.GB5320@kroah.com> <1363651261.4568.3.camel@thor.lan>
	 <20130319000505.GA6516@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 17:05 -0700, Greg Kroah-Hartman wrote:
> On Mon, Mar 18, 2013 at 08:01:01PM -0400, Peter Hurley wrote:
> > On Mon, 2013-03-18 at 16:59 -0700, Greg Kroah-Hartman wrote:
> > > On Mon, Mar 11, 2013 at 04:44:48PM -0400, Peter Hurley wrote:
> > > > Read lock recursion is no longer required for ldisc references;
> > > > remove mechanism.
> > > > 
> > > > Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> > > > ---
> > > >  drivers/tty/tty_ldsem.c   | 83 +++++------------------------------------------
> > > >  include/linux/tty_ldisc.h |  2 --
> > > >  2 files changed, 8 insertions(+), 77 deletions(-)
> > > 
> > > Wait, why did you add something 3 patches ago, only to remove it here?
> > > Why not just smush these patches together in the first place?
> > 
> > >From [PATCH v5 00/44] ldisc patchset...
> > 
> > On Mon, 2013-03-11 at 16:44 -0400, Peter Hurley wrote: 
> > > v5 changes:
> > > 
> > > After completing an audit of the recursive use of ldisc
> > > references, I discovered the _blocking_ recursive acquisition
> > > of ldisc references was limited to line disciplines misusing
> > > the tty_perform_flush() function.
> > > With that now resolved in,
> > >   'tty: Fix recursive deadlock in tty_perform_flush()'
> > > the recursion design in ldsem has been removed.
> > > 
> > > The recursion removal is in its own patch,
> > >   'tty: Remove ldsem recursion support'
> > > to ease review for those that have already reviewed the
> > > ldsem implementation.
> 
> Ah, ok.  Who reviewed the ldsem implementation?  I didn't see any other
> acks on it, or did I miss them?

Nobody ack'd it. What I meant by that was, if someone was working their
way through it, it would suck to have the base implementation all
different again, and much easier to review just the changes.



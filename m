Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046Ab3DAXra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:47:30 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58142 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129Ab3DAXr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:47:28 -0400
Date: Mon, 1 Apr 2013 16:47:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Jiri Slaby <jslaby@suse.cz>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Build breakage in 3.8.4 [was: Linux 3.8.4]
Message-ID: <20130401234726.GA25060@kroah.com>
References: <20130320201554.GA18281@kroah.com>
 <kidd01$2o6$1@ger.gmane.org>
 <514F5480.6040501@suse.cz>
 <CAGXu5jJdbDabBjNoaZUeqCT6a6yHqHcQNnqXNM6T1S=bwig8Fw@mail.gmail.com>
 <20130326161810.GB18581@kroah.com>
 <1364362994.3520.54.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364362994.3520.54.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:43:14AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-26 at 09:18 -0700, Greg KH wrote:
> > On Tue, Mar 26, 2013 at 08:56:20AM -0700, Kees Cook wrote:
> > > On Sun, Mar 24, 2013 at 12:31 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> > > > On 03/20/2013 11:25 PM, Sebastian Gottschall wrote:
> > > >
> > > >> Am 20.03.2013 21:15, schrieb Greg KH:
> > > >>> I'm announcing the release of the 3.8.4 kernel.
> > > > ...
> > > >>>        signal: always clear sa_restorer on execve
> > > >> consider that this kernel is not compileable on mips targets due the
> > > >> patch in kernel/signal.c
> > > >>
> > > >> SA_RESTORER is defined in mips, but sa_restorer does not exist on that
> > > >> platform
> > > >
> > > > The same for ia64...
> > > >
> > > > kernel/signal.c: In function 'flush_signal_handlers':
> > > > kernel/signal.c:441: error: 'struct sigaction' has no member named
> > > > 'sa_restorer'
> > > >
> > > > Do we need this in 3.0, 3.4, 3.8 too?
> > > > commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
> > > > Author: Andrew Morton <akpm@linux-foundation.org>
> > > > Date:   Wed Mar 13 14:59:34 2013 -0700
> > > >
> > > >     kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
> > > >
> > > >     __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
> > > >     later kernels, per Kees.
> > > 
> > > Hrm, if so, we'll need to also backport the changes that aded
> > > __ARCH_HAS_SA_RESTORER...
> > 
> > Ok, well, can someone provide me the needed patches?  Otherwise I will
> > have to revert the offending change from the stable releases.
> 
> For the third time... use the attached patch followed by Andrew's commit
> 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a.

Sorry for being thick, you are right, now applied, thanks.

greg k-h

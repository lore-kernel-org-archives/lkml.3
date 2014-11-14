Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaKNATx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:19:53 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37877 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaKNATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:19:52 -0500
Date: Thu, 13 Nov 2014 16:19:48 -0800
From: josh@joshtriplett.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pieter Smith <pieter@boesman.nl>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 51/56] drivers/char/mem: support compiling out splice
Message-ID: <20141114001948.GA30946@cloud>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-52-git-send-email-pieter@boesman.nl>
 <20141113220911.GA546@kroah.com>
 <CAPho-_JJGy0cwBVfWKL1Gt9ZQZM+Odo7W05bKQ2JLO+TM-ABJA@mail.gmail.com>
 <20141113223150.GB30412@cloud>
 <20141113233416.GC7678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113233416.GC7678@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 03:34:16PM -0800, Greg Kroah-Hartman wrote:
> On Thu, Nov 13, 2014 at 02:31:50PM -0800, josh@joshtriplett.org wrote:
> > [Please don't top-post.]
> > 
> > On Thu, Nov 13, 2014 at 11:23:46PM +0100, Pieter Smith wrote:
> > > Okay with moving the relevant functions to a new translation unit and
> > > squashing it out in the Makefile
> > 
> > No, you don't need to do that either.  Mark pipe_to_null and
> > splice_write_null as __maybe_unused, then wrap the initialization of
> > .splice_write = splice_write_null to make it .splice_write =
> > splice_p(splice_write_null).  That will avoid adding a single ifdef.
> 
> Again, ick, no.  You aren't saving anything "real" at all, just take out
> the splice core code, leave the file pointer alone, and never do that
> horrid "splice_p" stuff, ick ick ick.

Without doing the splice_p change (which should add zero lines of code,
total diffstat of -3+3 in this case, just a couple of __maybe_unused
tokens and a splice_p() in the initializer), the actual splice
implementations for filesystems and drivers won't get thrown away.  I
certainly agree that #ifdefs for those would be painful and not worth
it.  However, what problem would the proposed __maybe_unused / splice_p
cause?

On the other hand, I can *definitely* understand not bothering with
changing filesystems that nobody will use on a space-constrained system
(e.g.  cluster filesystems); the patch series could likely be narrowed
to just a half-dozen likely filesystems and drivers, all of which could
be done separately from the initial series removing the core splice
code.  Would that be more appealing?

- Josh Triplett

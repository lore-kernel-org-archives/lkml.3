Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280Ab3HIVyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:54:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031243Ab3HIVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:54:50 -0400
Date: Fri, 9 Aug 2013 14:54:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130809215449.GB21756@kroah.com>
References: <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202BC11.6040605@linuxtoys.org>
 <20130807214010.GA5902@kroah.com>
 <5202C1EE.40607@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202C1EE.40607@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:53:50PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> >>The proxy device nodes are application specific and need to be
> >>created as needed by applications.
> >
> >But applications do not have the permissions in a system to create
> >device nodes.  Nor should they need that permission.
> 
> Agreed.  But you need root permissions to install an application
> and part of that installation can be setting up systemd files
> that allocate resources at boot.

Do you have examples of those systemd files?  Last I looked, they didn't
have mknod permissions anymore, which is a good thing.

> Also, some applications start as root just so they can do this kind of
> allocation.  The app can (and should) drop root privileges when it
> can.

You shouldn't require root for a new feature, that seems strange.

Also, namespaces aren't addressed at all, but that's a totally different
issue...

> >>Allocation of minor numbers is an issue but that is an issue that
> >>is separate from the proxy module itself.
> >How is it separate, it seems tied directly to it as something that must
> >be handled properly.
> It can, but does not need to be handled in the kernel. It could
> be handled in user space.
> 
> >
> >>> Also, no, setting the permissions like this is not ok for a real system,
> >>> what is going to be in charge of setting the permissions on these random
> >>> device nodes?
> >> Again, compare proxy to a named pipe.  It is up the application
> >> writer to decide who gets read and write access to its proxy
> >> nodes.
> >
> > Ok, but to do so, you have to have root permissions to start with, which
> > is generally not going to happen on sane systems.  Only allowing root
> > access to this seems like a huge limitation.
> 
> As noted above, yes, root has to set it up and set the permissions,
> but this is hardly unusual, is it?

Yes it is, modern userspace does not create any device nodes anymore,
please let's not regress on that point.

thanks,

greg k-h

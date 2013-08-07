Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704Ab3HGViu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:38:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3HGVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:38:49 -0400
Date: Wed, 7 Aug 2013 14:40:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
Message-ID: <20130807214010.GA5902@kroah.com>
References: <20130803223828.GA14611@kroah.com>
 <51FECDA6.5070001@linuxtoys.org>
 <20130804231958.GA25418@kroah.com>
 <52003958.7080103@linuxtoys.org>
 <20130806094604.GE27889@kroah.com>
 <520299AB.1020607@linuxtoys.org>
 <20130807192714.GC2708@kroah.com>
 <5202A284.7010106@linuxtoys.org>
 <20130807195427.GB4121@kroah.com>
 <5202BC11.6040605@linuxtoys.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5202BC11.6040605@linuxtoys.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 02:28:49PM -0700, Bob Smith wrote:
> Greg Kroah-Hartman wrote:
> > You ignored my mknod comment.
> Yes, proxy is a type of IPC.  It's closest counterpart in the
> kernel now is a named pipe.   The kernel does not try to create
> named pipes automatically.  Named pipes are created deliberately
> by users with the mkfifo command or system call. Same with proxy.
> The proxy device nodes are application specific and need to be
> created as needed by applications.

But applications do not have the permissions in a system to create
device nodes.  Nor should they need that permission.

> Allocation of minor numbers is an issue but that is an issue that
> is separate from the proxy module itself.

How is it separate, it seems tied directly to it as something that must
be handled properly.

> > Also, no, setting the permissions like this is not ok for a real system,
> > what is going to be in charge of setting the permissions on these random
> > device nodes?
> Again, compare proxy to a named pipe.  It is up the application
> writer to decide who gets read and write access to its proxy
> nodes.

Ok, but to do so, you have to have root permissions to start with, which
is generally not going to happen on sane systems.  Only allowing root
access to this seems like a huge limitation.

thanks,

greg k-h

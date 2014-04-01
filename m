Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaDAPmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaDAPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:42:10 -0400
Date: Tue, 1 Apr 2014 08:44:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: handle out-of-bounds read/write
Message-ID: <20140401154419.GA4133@kroah.com>
References: <20140130094802.4ee29435@hananiah.suse.cz>
 <20140130132827.GA22557@kroah.com>
 <20140130150332.64419aee@hananiah.suse.cz>
 <20140130150407.GC1388@kroah.com>
 <20140401112930.465e3300@hananiah.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401112930.465e3300@hananiah.suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:29:30AM +0200, Petr Tesarik wrote:
> On Thu, 30 Jan 2014 07:04:07 -0800
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Thu, Jan 30, 2014 at 03:03:32PM +0100, Petr Tesarik wrote:
> > > On Thu, 30 Jan 2014 05:28:27 -0800
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > 
> > > > On Thu, Jan 30, 2014 at 09:48:02AM +0100, Petr Tesarik wrote:
> > > > > The loff_t type may be wider than phys_addr_t (e.g. on 32-bit systems).
> > > > > Consequently, the file offset may be truncated in the assignment.
> > > > > Currently, /dev/mem wraps around, which may cause applications to read
> > > > > or write incorrect regions of memory by accident.
> > > > 
> > > > Does that really happen?  If so, that's a userspace bug, right?
> > > 
> > > In my case, it was a userspace bug, indeed. But debugging would have
> > > been much easier if I saw read() fail with an EOF condition, rather
> > > than pretend that it actually read some bytes (from above 4G) on a
> > > 32-bit box.
> > 
> > Thats true.
> > 
> > Ok, I'll queue this up after 3.14-rc1 is out, thanks.
> 
> Hi Greg,
> 
> what happened to this patch? I still don't see it in git...

You got an email when it went into my git tree, and is set to be merged
to Linus for 3.15-rc1.

greg k-h

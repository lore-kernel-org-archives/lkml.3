Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaDAJ3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:29:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaDAJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:29:33 -0400
Date: Tue, 1 Apr 2014 11:29:30 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /dev/mem: handle out-of-bounds read/write
Message-ID: <20140401112930.465e3300@hananiah.suse.cz>
In-Reply-To: <20140130150407.GC1388@kroah.com>
References: <20140130094802.4ee29435@hananiah.suse.cz>
	<20140130132827.GA22557@kroah.com>
	<20140130150332.64419aee@hananiah.suse.cz>
	<20140130150407.GC1388@kroah.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 07:04:07 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Thu, Jan 30, 2014 at 03:03:32PM +0100, Petr Tesarik wrote:
> > On Thu, 30 Jan 2014 05:28:27 -0800
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Thu, Jan 30, 2014 at 09:48:02AM +0100, Petr Tesarik wrote:
> > > > The loff_t type may be wider than phys_addr_t (e.g. on 32-bit systems).
> > > > Consequently, the file offset may be truncated in the assignment.
> > > > Currently, /dev/mem wraps around, which may cause applications to read
> > > > or write incorrect regions of memory by accident.
> > > 
> > > Does that really happen?  If so, that's a userspace bug, right?
> > 
> > In my case, it was a userspace bug, indeed. But debugging would have
> > been much easier if I saw read() fail with an EOF condition, rather
> > than pretend that it actually read some bytes (from above 4G) on a
> > 32-bit box.
> 
> Thats true.
> 
> Ok, I'll queue this up after 3.14-rc1 is out, thanks.

Hi Greg,

what happened to this patch? I still don't see it in git...

Petr T

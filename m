Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3APEBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:01:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54177 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756664Ab3APEBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:01:17 -0500
Date: Tue, 15 Jan 2013 23:01:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more
 than 120 seconds"
In-Reply-To: <20130116003530.GK2668@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1301152253070.26877-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Tejun Heo wrote:

> Hello, Arjan.
> 
> On Tue, Jan 15, 2013 at 04:25:54PM -0800, Arjan van de Ven wrote:
> > async fundamentally had the concept of a monotonic increasing number,
> > and that you could always wait for "everyone before me".
> > then people (like me) wanted exceptions to what "everyone" means ;-(
> > I'm ok with going back to a single space and simplify the world.
> 
> If we want (or need) finer grained operation, we'll probably have to
> head the other direction, so that we can definitively tell that an
> async operation belongs to domains system, module load A and B, so
> that each waiter knows what to wait for.
> 
> The current domain implementation is somewhere inbetween.  It's not
> completely simplistic system and at the same time not developed enough
> to do properly stacked flushing.

I like your idea of chronological synchronization: Insist that anybody
who wants to flush async jobs must get a cookie, and then only allow
them to wait for async jobs started after the cookie was issued.

I don't know if this is possible with the current implementation.  It 
would require changing every call to async_synchronize_*(), and in a 
nontrivial way.  But it might provide a proper solution to all these 
problems.

Can you think of any reasons why it wouldn't work in principle?  It 
would prevent code from doing "wait until all currently-running async 
jobs have finished" -- but arguably, nobody should be allowed to do 
that anyway.

Alan Stern



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaLJEvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 23:51:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbaLJEvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 23:51:00 -0500
Date: Tue, 9 Dec 2014 23:50:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>, linux-serial@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH wq/for-3.19 3/3] workqueue: dump workqueues on sysrq-t
Message-ID: <20141210045057.GA11973@kroah.com>
References: <20141208174326.GB12274@htj.dyndns.org>
 <20141208174406.GC12274@htj.dyndns.org>
 <20141208174733.GD12274@htj.dyndns.org>
 <20141208100613.ecc66d89.akpm@linux-foundation.org>
 <20141208184035.GE12274@htj.dyndns.org>
 <20141208110515.7860d68baca2b3bd46c9dab7@linux-foundation.org>
 <20141208192229.GF12274@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208192229.GF12274@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 02:22:29PM -0500, Tejun Heo wrote:
> (cc'ing Greg for tty)
> 
> On Mon, Dec 08, 2014 at 11:05:15AM -0800, Andrew Morton wrote:
> > > Believe it or not, we already used up all alphanumerics if we count in
> > > the arch-specific ones.  Given that the workqueue information would
> > > primarily be useful in tracking down hangs and we'd want to see the
> > > dump of tasks in that case anyway, sysrq-t isn't a bad fit for
> > > appending workqueue dump.  If anybody has a better idea, I'm all ears.
> > 
> > Really.  Upper case?
> 
> Greg, would using uppercase chars for sysrq work over the different
> types of ttys?

I'm dragging in linux-serial@vger here also, but I think uppercase
characters will work from a tty standpoint.  I don't know about keyboard
scancodes, if they will do "odd" things wanting a shift with the sysrq
key at the same time.

Oh wait, I think that might be it, shift is needed for the sysrq key on
the keyboard to start with, right?  So there probably isn't a way to
test the difference of a lower/upper case key here.

I'm traveling this week, and don't have access to a "real" keyboard at
the moment, but this should be pretty easy for someone to test who has
one and cares about this type of thing {hint}.

thanks,

greg k-h

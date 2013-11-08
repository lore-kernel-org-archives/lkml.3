Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3KHKVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:21:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab3KHKVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:21:15 -0500
Date: Fri, 8 Nov 2013 11:21:13 +0100
From: Jan Kara <jack@suse.cz>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131108102113.GB6343@quack.suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-4-git-send-email-jack@suse.cz>
 <CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
 <20131107225733.GE2054@quack.suse.cz>
 <20131107232148.GE28130@localhost.localdomain>
 <20131107183717.0fc9eb6e@gandalf.local.home>
 <20131107234647.GG28130@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107234647.GG28130@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-11-13 00:46:49, Frederic Weisbecker wrote:
> On Thu, Nov 07, 2013 at 06:37:17PM -0500, Steven Rostedt wrote:
> > On Fri, 8 Nov 2013 00:21:51 +0100
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > Offloading to a workqueue would be perhaps better, and writing to the serial
> > > console could then be done with interrupts enabled, preemptible context, etc...
> > 
> > Oh God no ;-)  Adding workqueue logic into printk just spells a
> > nightmare of much more complexity for a critical kernel infrastructure.
> 
> But yeah that's scary, that means workqueues itself can't printk that safely.
> So, you're right after all.
  Yeah, we've been there (that was actually my initial proposal). But
Andrew and Steven (rightfully) objected and suggested irq_work should be
used instead.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

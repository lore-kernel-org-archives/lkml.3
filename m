Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaKKVQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:16:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaKKVQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:16:18 -0500
Date: Tue, 11 Nov 2014 22:16:15 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] mm/page-writeback.c: divide by zero in pos_ratio_polynom
 not fixed
Message-ID: <20141111211615.GE32298@quack.suse.cz>
References: <20141101082325.7be0463f@gandalf.local.home>
 <20141111201539.GA12333@quack.suse.cz>
 <20141111160448.61354836@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111160448.61354836@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-11-14 16:04:48, Steven Rostedt wrote:
> On Tue, 11 Nov 2014 21:15:39 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> 
> >   So I was looking into this but I have to say I don't understand where is
> > the problem. The registers clearly show that x_intercept - bdi_setpoint + 1
> > == 0 (in 32-bit arithmetics). Given:
> >    x_intercept = bdi_setpoint + span
> > 
> > We have that span + 1 == 0 and that means that:
> > ((thresh - bdi_thresh + 8 * write_bw) * (u64)x >> 16) == -1 (again in
> > 32-bit arithmetics). But I don't see how that can realistically happen...
> > 
> > Is this reproducible at all?
> > 
> 
> Unfortunately not. It only happened once, and I haven't been able to
> reproduce it again.
  BTW, how much memory does the machine have and what is
/proc/sys/vm/dirty_ratio and /proc/sys/vm/dirty_background_ratio (or
corresponding dirty_bytes, dirty_background_bytes if you are using them)?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

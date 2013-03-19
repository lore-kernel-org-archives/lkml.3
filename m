Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab3CSPqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:46:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab3CSPqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:46:03 -0400
Date: Tue, 19 Mar 2013 16:46:00 +0100
From: Jan Kara <jack@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, laijs@cn.fujitsu.com,
        fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        jmoyer@redhat.com
Subject: Re: [PATCH 3/4] writeback: replace custom worker pool
 implementation with unbound workqueue
Message-ID: <20130319154600.GC5222@quack.suse.cz>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
 <1362692649-25570-4-git-send-email-tj@kernel.org>
 <20130312150510.GF13152@quack.suse.cz>
 <20130318223244.GA11188@quack.suse.cz>
 <20130318223526.GH3042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318223526.GH3042@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 18-03-13 15:35:26, Tejun Heo wrote:
> On Mon, Mar 18, 2013 at 11:32:44PM +0100, Jan Kara wrote:
> >   I realized there may be one issue - so far we have a clear identification
> > which thread works for which bdi in the thread name (flush-x:y naming).
> > That was useful when debugging things. Now with your worker pool this is
> > lost, am I right? Would it be possible to restore that?
> 
> Unfortunately not directly.  It shouldn't be difficult to tell who's
> working on what from workqueue and writeback tracepoints tho.
  Well, but what you often get is just output of sysrq-w, or sysrq-t, or
splat from scheduler about stuck task. You often don't have the comfort of
tracing... Can't we somehow change 'comm' of the task when it starts
processing work of some bdi?
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaKWArI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 19:47:08 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54234 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaKWArH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 19:47:07 -0500
Date: Sat, 22 Nov 2014 16:47:04 -0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH percpu/for-3.18-fixes] percpu-ref: fix DEAD flag
 contamination of percpu pointer
Message-ID: <20141123004704.GA2245@kernel.org>
References: <995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org>
 <20141122142242.GB26007@htj.dyndns.org>
 <20141122170448.GA2436@kernel.org>
 <20141122170602.GE26007@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122170602.GE26007@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 12:06:02PM -0500, Tejun Heo wrote:
> On Sat, Nov 22, 2014 at 09:04:48AM -0800, Shaohua Li wrote:
> ...
> > > +	/*
> > > +	 * Theoretically, the following could test just ATOMIC; however,
> > > +	 * then we'd have to mask off DEAD separately as DEAD may be
> > > +	 * visible without ATOMIC if we race with percpu_ref_kill().  DEAD
> > > +	 * implies ATOMIC anyway.  Test them together.
> > > +	 */
> > > +	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
> > >  		return false;
> > 
> > this sounds not the correct answer. the DEAD/ATOMIC bit can be set by
> > percpu_ref_kill() right after the check.
> 
> Yes, but that's why we're fetching @percpu_ptr with ACCESS_ONCE()
> before checking the flags.

Ok, I forgot we cache the percpu_ptr. Yes, this does work. You can add my
signed-off in the patch.

Thanks,
Shaohua

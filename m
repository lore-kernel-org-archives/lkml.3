Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaAWS4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:56:47 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37777 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaAWS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:56:45 -0500
Date: Thu, 23 Jan 2014 13:56:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Crash in elevator_dispatch_fn() (e.g. deadline_dispatch()) when
 changing elevators.
Message-ID: <20140123185642.GA29712@htj.dyndns.org>
References: <1389995976.20232.27.camel@bobble.lax.corp.google.com>
 <20140118143145.GD3640@htj.dyndns.org>
 <1390319905.20232.38.camel@bobble.lax.corp.google.com>
 <1390405618.20232.42.camel@bobble.lax.corp.google.com>
 <1390502313.20232.49.camel@bobble.lax.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390502313.20232.49.camel@bobble.lax.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:38:33AM -0800, Frank Mayhar wrote:
> On Wed, 2014-01-22 at 07:46 -0800, Frank Mayhar wrote:
> > On Tue, 2014-01-21 at 07:58 -0800, Frank Mayhar wrote:
> > > Replacing?  Or adding to?  Is BYPASS always set when DYING is set?  (My
> > > guess is not but I haven't done an exhaustive analysis.)  So the
> > > relevant code snippet in __elv_next_request() would be:
> > > 		if (unlikely(blk_queue_dying(q)) ||
> > > 		    unlikely(blk_queue_bypass(q)) ||
> > > 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
> > > 			return NULL;
> > 
> > FYI, I've made this change and tested it.  I can't say for certain that
> > it fixes the crash (since it's one of those races that's difficult to
> > reproduce), but it does seem to pass all the tests I've thrown at it so
> > far.
> 
> Um, does anyone care about this?  Tejun?  Jens?  Anyone?
> 
> This is a real crash; it would be nice if someone would weigh in.

Yeah, we're gonna fix this and I *think* replacing dying with bypass
is the right thing to do as a queue is always bypassing when killed.
It's probably just that we're in the earlier part of the merge window
and I have some other things on my plate.  Will post a patch in a
couple days.

Thanks.

-- 
tejun

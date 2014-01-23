Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAWVOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:14:44 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46769 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaAWVOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:14:43 -0500
Message-ID: <1390511676.20232.54.camel@bobble.lax.corp.google.com>
Subject: Re: Crash in elevator_dispatch_fn() (e.g. deadline_dispatch()) when
 changing elevators.
From: Frank Mayhar <fmayhar@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 23 Jan 2014 13:14:36 -0800
In-Reply-To: <20140123185642.GA29712@htj.dyndns.org>
References: <1389995976.20232.27.camel@bobble.lax.corp.google.com>
	 <20140118143145.GD3640@htj.dyndns.org>
	 <1390319905.20232.38.camel@bobble.lax.corp.google.com>
	 <1390405618.20232.42.camel@bobble.lax.corp.google.com>
	 <1390502313.20232.49.camel@bobble.lax.corp.google.com>
	 <20140123185642.GA29712@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 13:56 -0500, Tejun Heo wrote:
> On Thu, Jan 23, 2014 at 10:38:33AM -0800, Frank Mayhar wrote:
> > On Wed, 2014-01-22 at 07:46 -0800, Frank Mayhar wrote:
> > > On Tue, 2014-01-21 at 07:58 -0800, Frank Mayhar wrote:
> > > > Replacing?  Or adding to?  Is BYPASS always set when DYING is set?  (My
> > > > guess is not but I haven't done an exhaustive analysis.)  So the
> > > > relevant code snippet in __elv_next_request() would be:
> > > > 		if (unlikely(blk_queue_dying(q)) ||
> > > > 		    unlikely(blk_queue_bypass(q)) ||
> > > > 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
> > > > 			return NULL;
> > > 
> > > FYI, I've made this change and tested it.  I can't say for certain that
> > > it fixes the crash (since it's one of those races that's difficult to
> > > reproduce), but it does seem to pass all the tests I've thrown at it so
> > > far.
> > 
> > Um, does anyone care about this?  Tejun?  Jens?  Anyone?
> > 
> > This is a real crash; it would be nice if someone would weigh in.
> 
> Yeah, we're gonna fix this and I *think* replacing dying with bypass
> is the right thing to do as a queue is always bypassing when killed.
> It's probably just that we're in the earlier part of the merge window
> and I have some other things on my plate.  Will post a patch in a
> couple days.

Thanks!

For the record, I've seriously beaten on the change above (despite it
maybe being redundant, it seems to do the right thing) and have seen no
problems so far.  I've changed it to _just_ check bypass and will beat
on that now.  If you're correct that a dying queue always has bypass set
then I anticipate no problems.
-- 
Frank Mayhar
310-460-4042


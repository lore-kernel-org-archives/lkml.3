Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaAWSik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:38:40 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43092 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaAWSij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:38:39 -0500
Message-ID: <1390502313.20232.49.camel@bobble.lax.corp.google.com>
Subject: Re: Crash in elevator_dispatch_fn() (e.g. deadline_dispatch()) when
 changing elevators.
From: Frank Mayhar <fmayhar@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Date: Thu, 23 Jan 2014 10:38:33 -0800
In-Reply-To: <1390405618.20232.42.camel@bobble.lax.corp.google.com>
References: <1389995976.20232.27.camel@bobble.lax.corp.google.com>
	 <20140118143145.GD3640@htj.dyndns.org>
	 <1390319905.20232.38.camel@bobble.lax.corp.google.com>
	 <1390405618.20232.42.camel@bobble.lax.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-22 at 07:46 -0800, Frank Mayhar wrote:
> On Tue, 2014-01-21 at 07:58 -0800, Frank Mayhar wrote:
> > Replacing?  Or adding to?  Is BYPASS always set when DYING is set?  (My
> > guess is not but I haven't done an exhaustive analysis.)  So the
> > relevant code snippet in __elv_next_request() would be:
> > 		if (unlikely(blk_queue_dying(q)) ||
> > 		    unlikely(blk_queue_bypass(q)) ||
> > 		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
> > 			return NULL;
> 
> FYI, I've made this change and tested it.  I can't say for certain that
> it fixes the crash (since it's one of those races that's difficult to
> reproduce), but it does seem to pass all the tests I've thrown at it so
> far.

Um, does anyone care about this?  Tejun?  Jens?  Anyone?

This is a real crash; it would be nice if someone would weigh in.
-- 
Frank Mayhar
310-460-4042


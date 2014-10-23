Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaJWQ3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:29:11 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51102 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaJWQ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:29:09 -0400
Date: Thu, 23 Oct 2014 21:58:59 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] block: wrong return value
Message-ID: <20141023162859.GB6590@sudip-PC>
References: <1414080271-6551-1-git-send-email-sudipm.mukherjee@gmail.com>
 <54492840.9050704@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54492840.9050704@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 10:09:36AM -0600, Jens Axboe wrote:
> On 10/23/2014 10:04 AM, Sudip Mukherjee wrote:
> > while compiling integer err was showing as a set but unused variable.
> > elevator_init_fn can be either cfq_init_queue or deadline_init_queue
> > or noop_init_queue.
> > all three of these functions are returning -ENOMEM if they fail to
> > allocate the queue.
> > so we should actually be returning the error code rather than
> > returning 0 always.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> > 
> > change in v2: added elevator_put
> > 
> >  block/elevator.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/elevator.c b/block/elevator.c
> > index 24c28b6..1267c2b 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -184,7 +184,7 @@ static void elevator_release(struct kobject *kobj)
> >  int elevator_init(struct request_queue *q, char *name)
> >  {
> >  	struct elevator_type *e = NULL;
> > -	int err;
> > +	int err = 0;
> 
> Why init it to 0?
not required actually. my initial thinking was that we are returning 0 on success or else the error code. so gave it a default value of 0.
but elevator_init_fn is returning 0 on success , so we will get 0 even if we do not initialize it.
should i resend after modifying it?

thanks
sudip
> 
> -- 
> Jens Axboe
> 

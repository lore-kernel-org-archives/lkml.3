Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaJWPIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:08:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55811 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaJWPIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:08:17 -0400
Date: Thu, 23 Oct 2014 20:38:05 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: wrong return value
Message-ID: <20141023150805.GA4924@sudip-PC>
References: <1414070409-4566-1-git-send-email-sudipm.mukherjee@gmail.com>
 <54490CB6.80306@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54490CB6.80306@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 08:12:06AM -0600, Jens Axboe wrote:
> On 10/23/2014 07:20 AM, Sudip Mukherjee wrote:
> > while compiling integer err was showing as a set but unused variable.
> > elevator_init_fn can be either cfq_init_queue or deadline_init_queue
> > or noop_init_queue.
> > all three of these functions are returning -ENOMEM if they fail to
> > allocate the queue. 
> > so we should actually be returning the error code rather than
> > returning 0 always.
> 
> That does look weird. You need an elevator_put() in the error case,
> though, ala:
> 
oops.. sorry i missed that elevator_get in the code.
I will send you v2 of the patch.

thanks
sudip

> err = e->ops.elevator_init_fn(q, e);
> if (err)
> 	elevator_put(e);
> 
> return err;
> 
> 
> -- 
> Jens Axboe
> 

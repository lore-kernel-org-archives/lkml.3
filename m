Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3C0Que (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3C0Qud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:50:33 -0400
Date: Wed, 27 Mar 2013 12:50:23 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 2/6] amso1100: convert to using idr_alloc_cyclic
Message-ID: <20130327125023.159e2309@tlielax.poochiereds.net>
In-Reply-To: <20130327162755.GC7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
	<1364390288-30968-3-git-send-email-jlayton@redhat.com>
	<20130327162755.GC7395@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 09:27:55 -0700
Tejun Heo <tj@kernel.org> wrote:

> On Wed, Mar 27, 2013 at 09:18:04AM -0400, Jeff Layton wrote:
> >  void c2_init_qp_table(struct c2_dev *c2dev)
> >  {
> >  	spin_lock_init(&c2dev->qp_table.lock);
> > -	idr_init(&c2dev->qp_table.idr);
> > +	idr_init_cyclic(&c2dev->qp_table.idr, 0);
> >  }
> 
> Why is this necessary?  In general, why is idr_init_cyclic()
> necessary?
> 
> Thanks.
> 

My thinking was that you might want to initialize the "cur" value to an
arbitrary value. All the current users though initialize it to the same
as the "start" value passed into idr_alloc_cyclic. Starting with it at
0 should be fine in all of the existing users.

I'll remove that in v2...

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>

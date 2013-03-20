Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3CTQEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:04:23 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44875 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3CTQEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:04:20 -0400
Date: Wed, 20 Mar 2013 09:04:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: laijs@cn.fujitsu.com, axboe@kernel.dk, jack@suse.cz,
        fengguang.wu@intel.com, jmoyer@redhat.com, zab@redhat.com,
        linux-kernel@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 08/10] workqueue: break init_and_link_pwq() into two
 functions and introduce alloc_unbound_pwq()
Message-ID: <20130320160412.GZ3042@htj.dyndns.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
 <1363737629-16745-9-git-send-email-tj@kernel.org>
 <CACvQF52vBmDi7nbg2O+CEo7M=n+RZSdEK45vyuCgv=o6R36KeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52vBmDi7nbg2O+CEo7M=n+RZSdEK45vyuCgv=o6R36KeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 11:52:03PM +0800, Lai Jiangshan wrote:
> > +static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
> > +                                       const struct workqueue_attrs *attrs)
> > +{
> > +       struct worker_pool *pool;
> > +       struct pool_workqueue *pwq;
> > +
> > +       pool = get_unbound_pool(attrs);
> > +       if (!pool)
> > +               return NULL;
> > +
> > +       pwq = kmem_cache_zalloc(pwq_cache, GFP_KERNEL);
> 
> this allocation is not numa-awared, you may use pool->node here.

Nice catch.  Will do.

Thanks.

-- 
tejun

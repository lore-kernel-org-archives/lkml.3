Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3C0Q2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:28:14 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:49915 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3C0Q2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:28:10 -0400
Date: Wed, 27 Mar 2013 09:27:55 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Tom Tucker <tom@opengridcomputing.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v1 2/6] amso1100: convert to using idr_alloc_cyclic
Message-ID: <20130327162755.GC7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
 <1364390288-30968-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364390288-30968-3-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 09:18:04AM -0400, Jeff Layton wrote:
>  void c2_init_qp_table(struct c2_dev *c2dev)
>  {
>  	spin_lock_init(&c2dev->qp_table.lock);
> -	idr_init(&c2dev->qp_table.idr);
> +	idr_init_cyclic(&c2dev->qp_table.idr, 0);
>  }

Why is this necessary?  In general, why is idr_init_cyclic()
necessary?

Thanks.

-- 
tejun

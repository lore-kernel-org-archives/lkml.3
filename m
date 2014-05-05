Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaEEPCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:02:23 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:52140 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbaEEPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:02:21 -0400
Date: Mon, 5 May 2014 11:02:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
Message-ID: <20140505150217.GH11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:08:58PM +0800, Lai Jiangshan wrote:
>  /**
> + * worker_unbind_pool() - unbind the worker from the pool
> + * @worker: worker which is bound to its pool
> + *
> + * Undo the pool-binding which had been done in create_worker()
> + */
> +static void worker_unbind_pool(struct worker *worker)

worker_unbind_from_pool() would be a better name but I don't think
using bind/unbind for this purpose is a good idea.  We already use
that pair of verbs for workers/pools being bound and unbound to CPUs.
I don't think we want to overload the terms for this purpose.  It gets
pretty confusing.  How about something like worker_detach_from_pool()
and later worker_attach_to_pool()?

Thanks.

-- 
tejun

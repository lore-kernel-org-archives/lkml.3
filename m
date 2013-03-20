Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3CTR60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:58:26 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47236 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3CTR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:58:25 -0400
Date: Wed, 20 Mar 2013 10:58:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] workqueue: separate out pools locking into
 pools_mutex
Message-ID: <20130320175818.GB29523@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-7-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363721306-2030-7-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 03:28:06AM +0800, Lai Jiangshan wrote:
> currently wq_mutext protects:
> 
> * worker_pool_idr and unbound_pool_hash
> * pool->refcnt
> * workqueues list
> * workqueue->flags, ->nr_drainers
> * workqueue_freezing
> 
> We can see that it protects very different things.
> So we need to split it and introduce a pools_mutex to protect:
> 
> * worker_pool_idr and unbound_pool_hash
> * pool->refcnt
> 
> (all are pools related field.)
> 
> workqueue_freezing is special, it is protected by both of wq_mutext
> pools_mutex. All are because get_unbound_pool() need to read it,
> which are because POOL_FREEZING is a bad design which will be fixed later.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Umm... I'm not sure about this one.  What's the benefit of further
splitting wq_mutex?  There's no identified bottleneck.  It just makes
things more complex.

Thanks.

-- 
tejun

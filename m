Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaDOQsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:48:00 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:61695 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaDOQr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:47:57 -0400
Date: Tue, 15 Apr 2014 12:47:52 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] workqueue: fix possible race condition when rescuer
 VS pwq-release
Message-ID: <20140415164752.GC30990@htj.dyndns.org>
References: <1395937212-4103-1-git-send-email-laijs@cn.fujitsu.com>
 <5335661E.7030408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335661E.7030408@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 08:07:58PM +0800, Lai Jiangshan wrote:
> +static inline void get_unbound_pwq(struct pool_workqueue *pwq)
> +{
> +	if (pwq->wq->flags & WQ_UNBOUND)
> +		get_pwq(pwq);
> +}
> +
>  /**
>   * put_pwq - put a pool_workqueue reference
>   * @pwq: pool_workqueue to put
> @@ -1075,6 +1081,12 @@ static void put_pwq(struct pool_workqueue *pwq)
>  	schedule_work(&pwq->unbound_release_work);
>  }
>  
> +static inline void put_unbound_pwq(struct pool_workqueue *pwq)
> +{
> +	if (pwq->wq->flags & WQ_UNBOUND)
> +		put_pwq(pwq);
> +}

Ugh... please drop these helpers.

> +		get_unbound_pwq(pwq);

Why not just do get_pwq() here?

Thanks.

-- 
tejun

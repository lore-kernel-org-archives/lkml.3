Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3ENPUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:20:52 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:46079 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3ENPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:20:51 -0400
Date: Tue, 14 May 2013 08:20:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: kfree issue, need check flag
 'WQ_UNBOUND' when processing failure.
Message-ID: <20130514152046.GC6795@mtj.dyndns.org>
References: <519236E0.4020301@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519236E0.4020301@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 09:06:40PM +0800, Chen Gang wrote:
>  err_destroy:
>  	destroy_workqueue(wq);
> +	if (flags & WQ_UNBOUND) {
> +err_free_wq:
> +		free_workqueue_attrs(wq->unbound_attrs);
> +		kfree(wq);
> +	}

Doesn't the above make the code free wq twice on after err_destroy?

-- 
tejun

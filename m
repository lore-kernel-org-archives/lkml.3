Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3HPQMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:12:34 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:57023 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab3HPQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:12:33 -0400
Date: Fri, 16 Aug 2013 12:12:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] print_worker_info: Handle pointer with more care
Message-ID: <20130816161229.GI2505@htj.dyndns.org>
References: <1376668606-32354-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376668606-32354-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:56:46PM +0200, Richard Weinberger wrote:
> The function has a nice comment:
> /*
>  * This function is called without any synchronization and @task
>  * could be in any state.  Be careful with dereferences.
>  */
> 
> But a few lines later it blindly dereferences a few pointers.
> E.g. It can happen that the worker function is already done,
> then worker->current_pwq is NULL.
...
>  	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
>  	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
> +	if (!pwq)
> +		goto print;
> +
>  	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
> +	if (!wq)
> +		goto print;
> +

But none of the above are dereferences.  &ptr->field is offset
calculation, not a dereference.

Thanks.

-- 
tejun

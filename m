Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3HSBrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:47:17 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24116 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab3HSBrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:47:15 -0400
Message-ID: <52117916.80107@huawei.com>
Date: Mon, 19 Aug 2013 09:47:02 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sheng Yang <sheng@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jens Axboe <jens.axboe@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] generic-ipi: Fix misleading smp_call_function_any() description
References: <51F5E6F8.1000801@huawei.com>
In-Reply-To: <51F5E6F8.1000801@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@elte.hu>

On 2013/7/29 11:52, Xie XiuQi wrote:
> After commit:8969a5ede0f9e17da4b943712429aef2c9bcd82b
> "generic-ipi: remove kmalloc()", wait = 0 can be guaranteed.
> 
> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
> Cc: Sheng Yang <sheng@linux.intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/smp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index fe9f773..b1c9034 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -278,8 +278,6 @@ EXPORT_SYMBOL(smp_call_function_single);
>   * @wait: If true, wait until function has completed.
>   *
>   * Returns 0 on success, else a negative status code (if no cpus were online).
> - * Note that @wait will be implicitly turned on in case of allocation failures,
> - * since we fall back to on-stack allocation.
>   *
>   * Selection preference:
>   *	1) current cpu if in @mask
> 



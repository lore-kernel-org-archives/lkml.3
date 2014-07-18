Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbaGREpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:45:04 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51465 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaGREpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:45:02 -0400
Message-ID: <53C8A622.4090902@huawei.com>
Date: Fri, 18 Jul 2014 12:44:18 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Do not copy old hash when resetting.
References: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
In-Reply-To: <1405311000-75943-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

What's your opinion on my v2 patch ( https://lkml.org/lkml/2014/7/14/839 )?

I have swapped if consitions following your suggestion.

On 2014/7/14 12:10, Wang Nan wrote:
> If we are going to reset hash, we don't need to duplicate old hash
> and remove every entries right after allocation.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/ftrace.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 5b372e3..52d6931 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3471,14 +3471,16 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
>  	else
>  		orig_hash = &ops->notrace_hash;
>  
> -	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	if (!reset)
> +		hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
> +	else
> +		hash = alloc_ftrace_hash(FTRACE_HASH_DEFAULT_BITS);
> +
>  	if (!hash) {
>  		ret = -ENOMEM;
>  		goto out_regex_unlock;
>  	}
>  
> -	if (reset)
> -		ftrace_filter_reset(hash);
>  	if (buf && !ftrace_match_records(hash, buf, len)) {
>  		ret = -EINVAL;
>  		goto out_regex_unlock;
> 



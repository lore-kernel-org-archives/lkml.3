Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab3ICFIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:08:18 -0400
Received: from intranet.asianux.com ([58.214.24.6]:26067 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3ICFIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:08:17 -0400
X-Spam-Score: -100.9
Message-ID: <52256E81.8070109@asianux.com>
Date: Tue, 03 Sep 2013 13:07:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: bsingharora@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/taskstats.c: add nla_nest_cancel() for failure
 processing between nla_nest_start() and nla_nest_end()
References: <5212D703.5080405@asianux.com> <5212D810.4040407@asianux.com>
In-Reply-To: <5212D810.4040407@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello maintainers:

Please help check this patch, when you have time.

Thanks.

On 08/20/2013 10:44 AM, Chen Gang wrote:
> When failure occurs between nla_nest_start() and nla_nest_end(), need
> call nla_nest_cancel() to clean up related things.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/taskstats.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 145bb4d..1db6808 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -404,11 +404,15 @@ static struct taskstats *mk_reply(struct sk_buff *skb, int type, u32 pid)
>  	if (!na)
>  		goto err;
>  
> -	if (nla_put(skb, type, sizeof(pid), &pid) < 0)
> +	if (nla_put(skb, type, sizeof(pid), &pid) < 0) {
> +		nla_nest_cancel(skb, na);
>  		goto err;
> +	}
>  	ret = nla_reserve(skb, TASKSTATS_TYPE_STATS, sizeof(struct taskstats));
> -	if (!ret)
> +	if (!ret) {
> +		nla_nest_cancel(skb, na);
>  		goto err;
> +	}
>  	nla_nest_end(skb, na);
>  
>  	return nla_data(ret);
> 


-- 
Chen Gang

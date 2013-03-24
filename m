Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3CXM2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 08:28:01 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:52618 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3CXM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 08:27:59 -0400
Message-ID: <514EF10E.6070506@cogentembedded.com>
Date: Sun, 24 Mar 2013 16:26:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, fuse-devel@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2, part4 09/39] mm: use totalram_pages instead of
 num_physpages at runtime
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com> <1364109934-7851-11-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1364109934-7851-11-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-03-2013 11:24, Jiang Liu wrote:

> The global variable num_physpages is scheduled to be removed, so use
> totalram_pages instead of num_physpages at runtime.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Cc: fuse-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
[...]

> diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
> index 4750d2b..94a99a1 100644
> --- a/net/ipv4/inet_fragment.c
> +++ b/net/ipv4/inet_fragment.c
> @@ -60,7 +60,7 @@ void inet_frags_init(struct inet_frags *f)
>
>   	rwlock_init(&f->lock);
>
> -	f->rnd = (u32) ((num_physpages ^ (num_physpages>>7)) ^
> +	f->rnd = (u32) ((totalram_pages ^ (totalram_pages>>7)) ^

    Wouldn't hurt to add spaces around >> for consistency's sake.

>   				   (jiffies ^ (jiffies >> 6)));
>
>   	setup_timer(&f->secret_timer, inet_frag_secret_rebuild,

WBR, Sergei


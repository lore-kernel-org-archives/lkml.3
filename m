Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3GYTPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:15:55 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:35014 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3GYTPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:15:51 -0400
Message-ID: <51F17977.9050606@gmail.com>
Date: Thu, 25 Jul 2013 15:16:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tom Rini <trini@ti.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <greg@kroah.com>, kosaki.motohiro@gmail.com
Subject: Re: [PATCH v2] numa: Mark __node_set as __always_inline
References: <1374776770-32361-1-git-send-email-trini@ti.com>
In-Reply-To: <1374776770-32361-1-git-send-email-trini@ti.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * The inline keyword gives the compiler room to decide to inline, or
> + * not inline a function as it sees best.  However, as these functions
> + * are called in both __init and non-__init functions, if they are not
> + * inlined we will end up with a section mis-match error (of the type of
> + * freeable items not being freed).  So we must use __always_inline here
> + * to fix the problem.  If other functions in the future also end up in
> + * this situation they will also need to be annotated as __always_inline
> + */
>   #define node_set(node, dst) __node_set((node), &(dst))
> -static inline void __node_set(int node, volatile nodemask_t *dstp)
> +static __always_inline void __node_set(int node, volatile nodemask_t *dstp)
>   {
>   	set_bit(node, dstp->bits);
>   }
> 

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


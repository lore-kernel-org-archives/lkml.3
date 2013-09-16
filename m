Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3IPU06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:26:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46005 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3IPU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:26:55 -0400
Message-ID: <5237695F.6010501@linux.vnet.ibm.com>
Date: Mon, 16 Sep 2013 13:26:07 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianguo Wu <wujianguo@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: use NUMA_NO_NODE
References: <5236FF32.60503@huawei.com>
In-Reply-To: <5236FF32.60503@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091620-9332-0000-0000-0000016FB935
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -1802,11 +1802,11 @@ static inline unsigned interleave_nid(struct mempolicy *pol,
>
>   /*
>    * Return the bit number of a random bit set in the nodemask.
> - * (returns -1 if nodemask is empty)
> + * (returns NUMA_NO_NOD if nodemask is empty)

s/NUMA_NO_NOD/NUMA_NO_NODE/

>    */
>   int node_random(const nodemask_t *maskp)
>   {
> -	int w, bit = -1;
> +	int w, bit = NUMA_NO_NODE;
>
>   	w = nodes_weight(*maskp);
>   	if (w)
>


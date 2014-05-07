Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaEGH0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:26:33 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:34975 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbaEGH0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:26:32 -0400
X-IronPort-AV: E=Sophos;i="4.97,1001,1389715200"; 
   d="scan'208";a="30182433"
Message-ID: <5369E11F.5010909@cn.fujitsu.com>
Date: Wed, 7 May 2014 15:30:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] workqueue: async worker destruction
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com> <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1398571754-12443-4-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 12:08 PM, Lai Jiangshan wrote:

>  
>  	spin_unlock_irq(&pool->lock);
> +
> +	wait_event_cmd(pool->workers_unbound,
> +		       idr_is_empty(&pool->worker_idr),
> +		       mutex_unlock(&pool->manager_mutex),
> +		       mutex_lock(&pool->manager_mutex));
> +


How about I wrap it as wait_event_mutex()?
(like wait_event_lock_irq() in kernel and pthread_cond_wait() in userspace)

>  	mutex_unlock(&pool->manager_mutex);
>  	mutex_unlock(&pool->manager_arb);
>  


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab3GaKjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 06:39:32 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:10794 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3GaKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 06:39:30 -0400
Message-ID: <51F8E922.3070008@huawei.com>
Date: Wed, 31 Jul 2013 18:38:26 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] relay: fix timer madness
References: <51F8E06C.1010408@huawei.com>
In-Reply-To: <51F8E06C.1010408@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/31 18:01, zhangwei(Jovi) wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> When I'm using ktap script to tracing all event tracepoints by relay
> transport, without this patch, the system will hang in few seconds.
> 
> I found the original patch discussion in 2007.
> http://marc.info/?l=linux-kernel&m=118544794717162&w=2
> (In that mail thread, the patch didn't fix that problem, but it fix
> the problem I encountered now)
> 
> Changed from origina patch:
>  - mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.
>  - mod timer interval changed from HZ/10 to jiffies + HZ/10, suggested
>    by Dan Carpenter, since mod_timer() takes an offset for interval.
> 
> Original patch changelog from Ingo in 2007:
> 
>   Remove timer calls (!!!) from deep within the tracing infrastructure.
>   This was totally bogus code that can cause lockups and worse.
>   Poll the buffer every 2 jiffies for now.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
Hi Andrew,

How about this patch? this version folded the suggestion from Ingo and Dan.

jovi


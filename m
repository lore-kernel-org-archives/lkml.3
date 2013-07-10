Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3GJDtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:49:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55690 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3GJDtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:49:52 -0400
Message-ID: <51DCD6F6.2080802@huawei.com>
Date: Wed, 10 Jul 2013 11:37:26 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] relay: fix timer madness
References: <51DCC48E.8050003@huawei.com>
In-Reply-To: <51DCC48E.8050003@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/10 10:18, zhangwei(Jovi) wrote:
> When I'm using ktap script to tracing all event tracepoints by relay
> transport, without this patch, the system will hang in few seconds.
> 
> I found the original patch discussion in 2007.
> http://marc.info/?l=linux-kernel&m=118544794717162&w=2
> (In that mail thread, the patch didn't fix that problem, but it fix
> the problem I encountered now)
> 
> Changed from v1:
> mod timer interval changed from jiffies+1 to HZ/10, as Ingo suggested.
> 
> Original patch changelog from Ingo in 2007:
> 
> Remove timer calls (!!!) from deep within the tracing infrastructure.
> This was totally bogus code that can cause lockups and worse.
> Poll the buffer every 2 jiffies for now.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I don't think this patch should have Andrew's signed-off-by?


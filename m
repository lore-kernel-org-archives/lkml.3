Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448Ab3DPBxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:53:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:60732 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DPBxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:53:31 -0400
Message-ID: <516CAF08.1090107@huawei.com>
Date: Tue, 16 Apr 2013 09:53:12 +0800
From: libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@gmail.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jiang.liu@huawei.com>, <guohanjun@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: Re: [PATCH 3.8-stable] sched/debug: Fix sd->*_idx limit range avoiding
 overflow
References: <1366035328-4780-1-git-send-email-jhbird.choi@samsung.com>
In-Reply-To: <1366035328-4780-1-git-send-email-jhbird.choi@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/15 22:15, Jonghwan Choi wrote:
> From: libin <huawei.libin@huawei.com>
> 
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?
> 

yes, I think this patch should be applied to the 3.8-stable tree. Thanks.
Libin

> ------------------
> 
> From: "libin <huawei.libin@huawei.com>"
> 
> commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream
> 
> Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on
> sysctl") was an incomplete bug fix.
> 
> This patch fixes sd->*_idx limit range to [0 ~ CPU_LOAD_IDX_MAX-1]
> avoiding array overflow caused by setting sd->*_idx to CPU_LOAD_IDX_MAX
> on sysctl.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> Cc: <jiang.liu@huawei.com>
> Cc: <guohanjun@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/51626610.2040607@huawei.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  kernel/sched/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..112a32a 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4948,7 +4948,7 @@ static void sd_free_ctl_entry(struct ctl_table **tablep)
>  }
>  
>  static int min_load_idx = 0;
> -static int max_load_idx = CPU_LOAD_IDX_MAX;
> +static int max_load_idx = CPU_LOAD_IDX_MAX-1;
>  
>  static void
>  set_table_entry(struct ctl_table *entry,
> 



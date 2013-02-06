Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3BFIZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 03:25:40 -0500
Received: from intranet.asianux.com ([58.214.24.6]:2898 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3BFIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 03:25:38 -0500
X-Spam-Score: -100.8
Message-ID: <5112137B.9030803@asianux.com>
Date: Wed, 06 Feb 2013 16:25:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/events: using uninitialized variable: slots.flexible
 for arm cross-compiling
References: <51120C03.20308@asianux.com>
In-Reply-To: <51120C03.20308@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  oh, sorry, it is my fault, please skip this patch.

gchen.

于 2013年02月06日 15:53, Chen Gang 写道:
> 
> for arm cross-compiling, in function __reserve_bp_slot:
> 
>   slots.flexible may be used without initializing.
> 
>     slots.flexible is not initialized when define it.
>     it is as a parameter passed to fetch_bp_busy_slots.
>     in function fetch_bp_busy_slots:
>       if bp->cpu < 0
>         slots->flexible will be used for comparing, firstly.
>         that will cause issue.
> 
> 
> building:
>   make EXTRA_CFLAGS=-W ARCH=arm
>   ...
>   linux/kernel/events/hw_breakpoint.c:300:
>     warning: missing initializer
>   linux/kernel/events/hw_breakpoint.c:300:
>     warning: (near initialization for 'slots.flexible')
>   ...
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/events/hw_breakpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index fe8a916..ef69215 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -297,7 +297,7 @@ __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
>   */
>  static int __reserve_bp_slot(struct perf_event *bp)
>  {
> -	struct bp_busy_slots slots = {0};
> +	struct bp_busy_slots slots = {0, 0};
>  	enum bp_type_idx type;
>  	int weight;
>  
> 


-- 
Chen Gang

Asianux Corporation

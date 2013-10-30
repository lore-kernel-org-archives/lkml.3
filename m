Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3J3PPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:15:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3J3PPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:15:41 -0400
Message-ID: <52712293.90808@infradead.org>
Date: Wed, 30 Oct 2013 08:15:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/wait.h: add ';' for the statement which
 missed it.
References: <52708623.504@asianux.com>
In-Reply-To: <52708623.504@asianux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/13 21:08, Chen Gang wrote:
> Add ';' for the statement, or can not pass compiling. The related error
> (for powerpc allmodconfig):
> 
>     CC      block/blk-mq.o
>   block/blk-mq.c: In function ‘blk_mq_queue_enter’:
>   block/blk-mq.c:108:8: error: expected ‘;’ before ‘__ret’
>   block/blk-mq.c:108:6: error: void value not ignored as it ought to be
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

I have that same patch on my machine but never posted it.

Thanks.

> ---
>  include/linux/wait.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 7f8caa5..fcc9680 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -768,7 +768,7 @@ do {									\
>  	int __ret = 0;							\
>  	if (!(condition))						\
>  		__ret = __wait_event_interruptible_lock_irq(wq,		\
> -						condition, lock,)	\
> +						condition, lock,);	\
>  	__ret;								\
>  })
>  
> 


-- 
~Randy

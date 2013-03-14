Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3CNOpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972Ab3CNOpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:45:05 -0400
Date: Thu, 14 Mar 2013 15:43:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, edumazet@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] task_work: check callback if it's NULL
Message-ID: <20130314144307.GB16136@redhat.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com> <1363247865-3531-2-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363247865-3531-2-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, liguang wrote:
>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/task_work.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 0bf4258..f458b08 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -75,7 +75,8 @@ void task_work_run(void)
>
>  		do {
>  			next = work->next;
> -			work->func(work);
> +			if (unlikely(work->func))
> +				work->func(work);

Why?

Oleg.


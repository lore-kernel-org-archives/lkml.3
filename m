Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936649Ab3DRWK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:10:59 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63221 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3DRWK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
Date: Fri, 19 Apr 2013 06:10:57 +0800
Message-ID: <CACvQF509UnU5RLtoxhnwmfdkudAR+_oWDKLfpq28WeKcUst5qw@mail.gmail.com>
Subject: Re: [PATCH 0/8] workqueue: advance concurrency management
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On Mon, Apr 15, 2013 at 12:41 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> I found the early-increasing nr_running in wq_worker_waking_up() is useless
> in many cases. it tries to avoid waking up idle workers for pending work item.
> but delay increasing nr_running does not increase waking up idle workers.
>
> so we delay increasing and remove wq_worker_waking_up() and ...
>
> enjoy a simpler concurrency management.
>
> Lai Jiangshan (8):
>   workqueue: remove @cpu from wq_worker_sleeping()
>   workqueue: use create_and_start_worker() in manage_workers()
>   workqueue: remove cpu_intensive from process_one_work()
>   workqueue: quit cm mode when sleeping
>   workqueue: remove disabled wq_worker_waking_up()
>   workqueue: make nr_running non-atomic
>   workqueue: move worker->flags up
>   workqueue: rename ->nr_running to ->nr_cm_workers
>
>  kernel/sched/core.c         |    6 +-
>  kernel/workqueue.c          |  234 +++++++++++++++---------------------------
>  kernel/workqueue_internal.h |    9 +-
>  3 files changed, 89 insertions(+), 160 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3BRQ3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:29:07 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40562 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3BRQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:29:06 -0500
Message-ID: <512256C7.2020203@gmail.com>
Date: Tue, 19 Feb 2013 00:28:55 +0800
From: Lai Jiangshan <eag0628@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 00/15] workqueue: enhance locking and lookup worker
 via ID
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/13 00:12, Lai Jiangshan wrote:
> Core patches are patch 1, patch 9, patch 13
>
> Patch 1: enhance locking
> Patch 9: recorde worker id to work->data instead of pool id
> 	 lookup worker via worker ID if offq
> Patch 13:also lookup worker via worker ID if running&&queued,
> 	 remove lookup via hashtable
>
> Patch 6-8: ensure modification to worker->pool is under pool lock held
> Patch 14: remove hashtable totally
>
> other patch is preparing-patch or cleanup.

Patchset is on top of tj/for-3.9
8d03ecfe471802d6afe97da97722b6924533aa82
workqueue: reimplement is_chained_work() using current_wq_worker()

Some other patches will be sent tomorrow or later(need to consider/merge 
with your review comments at first)

Thanks,
lai

>
>
> Lai Jiangshan (15):
>    workqueue: add lock_work_pool()
>    workqueue: allow more work_pool id space
>    workqueue: remname worker->id to worker->id_in_pool
>    workqueue: add worker's global worker ID
>    workqueue: only set pool id when the work is running
>    workqueue: use current instead of worker->task in
>      worker_maybe_bind_and_lock()
>    workqueue: change argument of worker_maybe_bind_and_lock() to pool
>    workqueue: only change worker->pool with pool lock held
>    workqueue: use worker id instead
>    workqueue: avoid unneeded calls to get_work_cwq(work)
>    workqueue: split work_flags to delayed_flags and color_flags in
>      __queue_work()
>    workqueue: add extra flags to set_work_worker_and_keep_pending()
>    workqueue: also record worker in work->data if running&&queued
>    workqueue: convert busy hash to busy list
>    workqueue: queue worker to busy list
>
>   include/linux/workqueue.h   |   25 +-
>   kernel/workqueue.c          |  522 ++++++++++++++++++++++++-------------------
>   kernel/workqueue_internal.h |   17 +-
>   3 files changed, 314 insertions(+), 250 deletions(-)
>


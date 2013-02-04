Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3BDWMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:12:12 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:39497 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3BDWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:12:11 -0500
Date: Mon, 4 Feb 2013 14:12:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] workqueue: record global worker ID instead of pool
 ID in work->data when off-queue
Message-ID: <20130204221203.GA8068@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-14-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

One more thing.

On Fri, Feb 01, 2013 at 02:41:36AM +0800, Lai Jiangshan wrote:
> @@ -1216,7 +1198,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
>  		list_del_init(&work->entry);
>  		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
>  
> -		clear_work_cwq(work, pool->id);
> +		/* Does the work is still running? */
> +		worker = find_worker_executing_work(pool, work);
> +		worker_gwid = worker ? worker->gwid: WORK_OFFQ_WORKER_NONE;
> +		clear_work_cwq(work, worker_gwid);

Any chance we can remove the busy_hash?  Having to keep it around
isn't a big deal but it would be nice if can get rid of it.

Thanks.

-- 
tejun

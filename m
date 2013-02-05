Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3BEQpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:45:30 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:34459 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3BEQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:45:25 -0500
Date: Tue, 5 Feb 2013 08:45:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it
 on pool
Message-ID: <20130205164520.GA4276@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
 <20130204212808.GC27963@mtj.dyndns.org>
 <51111E9A.4000504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51111E9A.4000504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Tue, Feb 05, 2013 at 11:00:42PM +0800, Lai Jiangshan wrote:
> The @cpu can be WORK_CPU_UNBOUND, and the current code will delay
> to determine on which cpu should this work be queued until timeout,
> I didn't want to change this behavior when I wrote the patch.

Hmmm?  The current code determines the CPU on queue_delayed_work().

       	/*
	 * If we cannot get the last pool from @work directly,
	 * select the last CPU such that it avoids unnecessarily
	 * triggering non-reentrancy check in __queue_work().
	 */
	lcpu = cpu;
	if (pool)
		lcpu = pool->cpu;
	if (lcpu == WORK_CPU_UNBOUND)
		lcpu = raw_smp_processor_id();

@lcpu is never WORK_CPU_UNBOUND for bound workqueues and for unbound
workqueues we of course have cwq for WORK_CPU_UNBOUND.

> PS, again, @cpu and @wq can be saved/encoded in dwork.work.entry if needed.

If possible, I'd much prefer to keep it inside delayed_work() proper.

Thanks.

-- 
tejun

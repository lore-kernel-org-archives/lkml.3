Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3BFOSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:18:15 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44081 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BFOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:18:14 -0500
Date: Wed, 6 Feb 2013 06:18:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] workqueue: don't set work cwq until we queued it
 on pool
Message-ID: <20130206141808.GA15081@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
 <20130204212808.GC27963@mtj.dyndns.org>
 <51111E9A.4000504@gmail.com>
 <20130205164520.GA4276@mtj.dyndns.org>
 <CACvQF52FTPEdMTOK29EM2kbxX8KCT3xTyZe1YJG3oe4RAiUk_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52FTPEdMTOK29EM2kbxX8KCT3xTyZe1YJG3oe4RAiUk_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, Feb 06, 2013 at 07:35:24PM +0800, Lai Jiangshan wrote:
> > @lcpu is never WORK_CPU_UNBOUND for bound workqueues and for unbound
> > workqueues we of course have cwq for WORK_CPU_UNBOUND.
> 
> 
> Are you sure?
> @lcpu is only used when it tries to set cwq to work data without
> breaking nrt logic.
> 
> void delayed_work_timer_fn(unsigned long __data)
> {
> 	struct delayed_work *dwork = (struct delayed_work *)__data;
> 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
> 
> 	/* should have been called from irqsafe timer with irq already off */
> 	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
> }

Ah, you're right.  I was confused about ->cpu and cwq in ->data.
Yeah, let's just add ->wq as the original patch.

Thanks.

-- 
tejun

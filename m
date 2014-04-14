Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaDNXWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:22:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37682 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaDNXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:22:23 -0400
Date: Tue, 15 Apr 2014 01:22:20 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 29/38] tick-sched: remove wrapper around
 __tick_nohz_task_switch()
Message-ID: <20140414232218.GE1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
 <b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:53:51PM +0530, Viresh Kumar wrote:
> __tick_nohz_task_switch() was called only from tick_nohz_task_switch() and there
> is nothing much in tick_nohz_task_switch() as well. IOW, we don't need
> unnecessary wrapper over __tick_nohz_task_switch() to be there. Merge all code
> from __tick_nohz_task_switch() into tick_nohz_task_switch() and move it to
> tick-sched.c.
> 
> This also moves check for tick_nohz_tick_stopped() outside of irq_save()
> context.

No, the wrapper is there on purpose in order to optimize the full dynticks off case in
the context switch path with the jump label'ed check on tick_nohz_full_enabled().

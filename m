Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3GHPho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:37:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57304 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3GHPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:37:42 -0400
Date: Mon, 8 Jul 2013 17:37:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tj@kernel.org, davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Livi@jasper.es
Subject: Re: [PATCH V5 0/5] Queue work on power efficient wq
Message-ID: <20130708153716.GF29556@pengutronix.de>
References: <cover.1366803121.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1366803121.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 24, 2013 at 05:12:52PM +0530, Viresh Kumar wrote:
> This patchset was called: "Create sched_select_cpu() and use it for workqueues"
> for the first three versions.
> 
> Earlier discussions over v3, v2 and v1 can be found here:
> https://lkml.org/lkml/2013/3/18/364
> http://lists.linaro.org/pipermail/linaro-dev/2012-November/014344.html
> http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html
> 
> V4 is here:
> https://lkml.org/lkml/2013/3/31/55
> 
> Workqueues can be performance or power oriented. For performance we may want to
> keep them running on a single cpu, so that it remains cache hot. For power we
> can give scheduler the liberty to choose target cpu for running work handler.
> 
> Later one (Power oriented WQ) can be achieved if the workqueue is allocated with
> WQ_UNBOUND flag. Enabling CONFIG_WQ_POWER_EFFICIENT will set
> 'wq_power_efficient' to 'true'. Setting 'power_efficient' boot param will
> override value of 'wq_power_efficient' variable. When 'wq_power_efficient' is
> set to 'true', we will convert WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq
> allocation. And so scheduler will have the liberty to choose where to run this
> work.
> 
> Here we are migrating few users of workqueues to WQ_POWER_EFFICIENT. These
> drivers are found to be very much active on idle or lightly busy system and
> using WQ_POWER_EFFICIENT for these gave impressive results.
> 
> These would be used in power saving mode only if relevant configs are enabled
> at compile time or in bootargs. Otherwise behavior is unchanged.
> 
> Setup:
> -----
> - ARM Vexpress TC2 - big.LITTLE CPU
> - Core 0-1: A15, 2-4: A7
> - rootfs: linaro-ubuntu-devel
This patch set hit my tree now. I wonder if it makes sense to make
WQ_POWER_EFFICIENT_DEFAULT depend on SMP. (Oh wait, big.LITTLE isn't
SMP, so probably there is a better symbol to depend on?)

Just my 2 cent
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

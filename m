Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaBLSXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:23:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50959 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaBLSXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:23:41 -0500
Date: Wed, 12 Feb 2014 19:23:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, tj@kernel.org
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140212182336.GD5496@localhost.localdomain>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210184729.GL4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:47:29AM -0800, Paul E. McKenney wrote:
> On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> > Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Thank you all, queued for 3.15.
> 
> We should also have some facility for moving the SRCU workqueues to
> housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
> this patch already have that effect?

Kevin Hilman and me plan to try to bring a new Kconfig option that could let
us control the unbound workqueues affinity through sysfs.

The feature actually exist currently but is only enabled for workqueues that
have WQ_SYSFS. Writeback and raid5 are the only current users.

See for example: /sys/devices/virtual/workqueue/writeback/cpumask

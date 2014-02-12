Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaBLTYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:24:04 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:62639 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBLTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:24:01 -0500
Date: Wed, 12 Feb 2014 14:23:54 -0500
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140212192354.GC26809@htj.dyndns.org>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <20140212190241.GD4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212190241.GD4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 12, 2014 at 11:02:41AM -0800, Paul E. McKenney wrote:
> +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
> +	to force the WQ_SYSFS workqueues to run on the specified set
> +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
> +	"ls sys/devices/virtual/workqueue".

One thing to be careful about is that once published, it becomes part
of userland visible interface.  Maybe adding some words warning
against sprinkling WQ_SYSFS willy-nilly is a good idea?

Thanks.

-- 
tejun

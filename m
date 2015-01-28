Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbbA2Blh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:51069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbbA2Ble (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:34 -0500
Date: Wed, 28 Jan 2015 12:53:32 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch] cpuset: fix crash when adding CPUs to an empty set
Message-ID: <20150128115332.GD23038@twins.programming.kicks-ass.net>
References: <1421820981.16275.1.camel@marge.simpson.net>
 <54C84C74.9080102@huawei.com>
 <1422417235.5716.5.camel@marge.simpson.net>
 <54C86494.6020509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C86494.6020509@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 12:24:52PM +0800, Zefan Li wrote:
> > sched: Fix crash if cpuset_cpumask_can_shrink() is passed an empty cpumask
> > 
> > While creating an exclusive cpuset, we passed cpuset_cpumask_can_shrink()
> > an empty cpumask (cur), and dl_bw_of(cpumask_any(cur)) made boom with it.
> > 

Is this the case where a new cpuset doesn't yet have CPUs assigned?


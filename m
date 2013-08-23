Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3HWKEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:04:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46234 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab3HWKED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:04:03 -0400
Date: Fri, 23 Aug 2013 12:03:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 07/10] sched, fair: Optimize find_busiest_queue()
Message-ID: <20130823100340.GP31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.527872672@infradead.org>
 <5217194B.2020209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5217194B.2020209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:41:55PM +0530, Preeti U Murthy wrote:
> Hi Peter,
> 
> On 08/19/2013 09:31 PM, Peter Zijlstra wrote:
> 
> In the load balancing code, looks to me that
> cpumask_copy(cpus, cpu_active_mask) is not updating the env.cpus at all,
> before calling find_busiest_group(). Am I missing something?
> 
> Should not cpumask_copy() below be before we update the env.cpus parameter?

Nah, its all pointers.

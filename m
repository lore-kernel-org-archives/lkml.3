Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750802Ab3HSEUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:20:31 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51538 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3HSEUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:20:25 -0400
Message-ID: <52119C6B.1090009@linux.vnet.ibm.com>
Date: Mon, 19 Aug 2013 09:47:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 5/6] sched, fair: Make group power more consitent
References: <20130816101221.028189677@chello.nl> <20130816101545.290832815@infradead.org>
In-Reply-To: <20130816101545.290832815@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081904-0260-0000-0000-0000037C5434
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 08/16/2013 03:42 PM, Peter Zijlstra wrote:

I have a few comments and clarification to seek.

1. How are you ensuring from this patch that sgs->group_power does not
change over the course of load balancing?

    The only path to update_group_power() where sg->sgp->power gets
updated, is from update_sg_lb_stats(). You are updating sgs->group_power
in update_sg_lb_stats(). Any change to group->sgp->power will get
reflected in sgs->group_power as well right?

2. This point is aside from your patch. In the current implementation,
each time the cpu power gets updated in update_cpu_power(), should not
the power of the sched_groups comprising of that cpu also get updated?
Why wait till the load balancing is done at the sched_domain level of
that group, to update its group power?

Regards
Preeti U Murthy


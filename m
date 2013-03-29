Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3C2Lpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:45:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab3C2Lpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:45:30 -0400
Message-ID: <1364557514.5053.85.camel@laptop>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 29 Mar 2013 12:45:14 +0100
In-Reply-To: <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> There is not enough reason to place this checking at
> update_sg_lb_stats(),
> except saving one iteration for sched_group_cpus. But with this
> change,
> we can save two memset cost and can expect better compiler
> optimization,
> so clean-up may be more beneficial to us.

It would be good if you'd described what you actually did, there's a
lot of code movement and now I have to figure out wth you did and why.


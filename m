Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3LMUDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:03:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52433 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab3LMUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:03:36 -0500
Date: Fri, 13 Dec 2013 21:03:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
Message-ID: <20131213200303.GI2480@laptop.programming.kicks-ass.net>
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386061556-28233-1-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I had a quick peek at the actual patches.

afaict we're now using weighted_cpuload() aka runnable_load_avg as the
->cpu_load. Whatever happened to also using the blocked_avg?

I totally hate patch 4; it seems like a random hack to make up for the
lack of blocked_avg.

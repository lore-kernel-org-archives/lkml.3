Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561Ab3BMOPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:15:09 -0500
Received: from mailhost-y5-m4.nerim-networks.com ([78.40.49.242]:28504 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759384Ab3BMOPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:15:07 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 09:15:07 EST
Date: Wed, 13 Feb 2013 15:08:43 +0100
From: Damien Wyart <damien.wyart@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sched: fix env->src_cpu for active migration
Message-ID: <20130213140843.GA21308@brouette>
References: <1360675195-4017-1-git-send-email-vincent.guittot@linaro.org>
 <20130213061853.GA4043@brouette>
 <CAKfTPtDCPKeQpcS4mQc7Jp7+wK2EuvnCUqAzL7SOELVVL3jztw@mail.gmail.com>
 <20130213092154.GA4481@brouette>
 <CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDprVAA0o6sTugYk8RiaUkGXUmSvd4RJbTEhNkKj7B-5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vincent Guittot <vincent.guittot@linaro.org> [2013-02-13 13:08]:
> Damien,
> Regarding your sched_domain config and especially the flags field, you
> should not be impacted by my patch because
> - need_active_balance is the only new place that use env->src_cpu in
> the load_balance function
> - and your machine will never test the condition: "env->src_cpu >
> env->dst_cpu" in need_active_balance because  SD_ASYM_PACKING is not
> set in your config

> Have you tested the patch with others that could have modified the
> load_balance function ?

Yes, sorry, I should have been more precise in my initial report: your
patch was not applied on top of vanilla 3.8-rc7, but a few other patches
were also present. Seems the ones impacting load_balance are from
Frederic's nohz work
(http://git.kernel.org/?p=linux/kernel/git/frederic/linux-dynticks.git;a=shortlog;h=refs/heads/3.8-rc6-nohz4)

The patches from there modifying load_balance are:
- "sched: Update nohz rq clock before searching busiest group on load balancing"
- "sched: Update clock of nohz busiest rq before balancing"

In this test, I did not use any kernel parameter related to this
patchset (full_nohz, etc.).

I am adding Frederic in Cc, not sure if the breakage is to be
investigated on your side or his...


Thanks for your explanations,
-- 
Damien

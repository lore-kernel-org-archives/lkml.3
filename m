Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaGHKdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:33:53 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1248 "EHLO
	esgaroth.tuxoid.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGHKdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:33:51 -0400
X-Greylist: delayed 2532 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2014 06:33:51 EDT
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "xiaofeng.yan" <xiaofeng.yan@huawei.com>, mingo@redhat.com,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        xiaofeng.yan2012@gmail.com
Date: Tue, 08 Jul 2014 11:49:49 +0200
In-Reply-To: <20140708093334.GD6758@twins.programming.kicks-ass.net>
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
	 <20140708093334.GD6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1404812992.29824.2.camel@thorin>
Mime-Version: 1.0
X-DCC-URT-Metrics: esgaroth.petrovitsch.priv.at 1060; Body=6 Fuz1=6 Fuz2=6
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.2 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2014-07-08 at 11:33 +0200, Peter Zijlstra wrote:
[...]
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index fc4f98b1258f..e1e24eea8061 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -999,8 +999,7 @@ static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>  {
>  	s64 delta = p->dl.dl_runtime - p->dl.runtime;

This line can be removed as well (an then we have a one-line
function ....).

> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	hrtick_start(rq, p->dl.runtime);
>  }
>  #endif


	Bernd
-- 
"I dislike type abstraction if it has no real reason. And saving
on typing is not a good reason - if your typing speed is the main
issue when you're coding, you're doing something seriously wrong."
    - Linus Torvalds


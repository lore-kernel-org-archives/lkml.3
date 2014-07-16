Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964997AbaGPPSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934419AbaGPPSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:18:23 -0400
Date: Wed, 16 Jul 2014 11:17:48 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Bruno Wolff III <bruno@wolff.to>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140716151748.GC2460@hansolo.jdub.homelinux.org>
References: <20140716145546.GA6922@wolff.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716145546.GA6922@wolff.to>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Dietmar in since he is the original author.

josh

On Wed, Jul 16, 2014 at 09:55:46AM -0500, Bruno Wolff III wrote:
> caffcdd8d27ba78730d5540396ce72ad022aff2c has been causing crashes
> early in the boot process on one of three machines I have been
> testing the kernel on. On that one machine it happens every boot. It
> happens before netconsole is functional.
> 
> A partial revert of the commit fixes the problem. I do not know why
> the commit is broken though.
> 
> I have filed https://bugzilla.kernel.org/show_bug.cgi?id=80251 for
> this issue.
> 
> The problem happens on both Fedora and Linus kernels.
> 
> git diff caffcdd8d27ba78730d5540396ce72ad022aff2c^ caffcdd8d27ba78730d5540396ce72ad022aff2c
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 45d077ed24fb..6340c601475d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5794,8 +5794,6 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>                        continue;
> 
>                group = get_group(i, sdd, &sg);
> -               cpumask_clear(sched_group_cpus(sg));
> -               sg->sgp->power = 0;
>                cpumask_setall(sched_group_mask(sg));
> 
>                for_each_cpu(j, span) {
> 
> By rc5 the second line can't be added back because the structure has
> changed. However adding back cpumask_clear(sched_group_cpus(sg)); to
> rc5 got things working for me again.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbaIVTAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:00:52 -0400
Received: from cethen.legt.fr ([92.243.2.98]:50598 "EHLO cethen.legt.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbaIVTAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:00:51 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 15:00:50 EDT
From: Vincent Legout <vincent@legout.info>
To: Juri Lelli <juri.lelli@arm.com>
Cc: peterz@infradead.org, mingo@redhat.com, juri.lelli@gmail.com,
        raistlin@linux.it, michael@amarulasolutions.com, fchecconi@gmail.com,
        daniel.wagner@bmw-carit.de, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sched/deadline: clear dl_entity params when setscheduling to different class
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
	<1411118561-26323-2-git-send-email-juri.lelli@arm.com>
Date: Mon, 22 Sep 2014 14:50:33 -0400
In-Reply-To: <1411118561-26323-2-git-send-email-juri.lelli@arm.com> (Juri
	Lelli's message of "Fri, 19 Sep 2014 10:22:39 +0100")
Message-ID: <87ppentrpi.fsf@cecht.legt.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Juri Lelli <juri.lelli@arm.com> writes:

> When a task is using SCHED_DEADLINE and the user setschedules it to a different
> class its sched_dl_entity static parameters are not cleaned up. This causes a
> bug if the user sets it back to SCHED_DEADLINE with the same parameters again.
> The problem resides in the check we perform at the very beginning of
> dl_overflow():
>
> 	if (new_bw == p->dl.dl_bw)
> 		return 0;
>
> This condition is met in the case depicted above, so the function returns and
> dl_b->total_bw is not updated (the p->dl.dl_bw is not added to it). After this,
> admission control is broken.
>
> This patch fixes the thing, properly clearing static parameters for a task
> that ceases to use SCHED_DEADLINE.

Thanks, this fixes the issue I had:

Tested-by: Vincent Legout <vincent@legout.info>

Thanks,
Vincent

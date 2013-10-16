Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3JPG5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:57:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3JPG5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:57:14 -0400
Message-ID: <1381906601.5472.62.camel@marge.simpson.net>
Subject: Re: sched/rt: Pick up the throttled rt tasks in case no other
 non-rt tasks
From: Mike Galbraith <bitbucket@online.de>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 08:56:41 +0200
In-Reply-To: <1381938216.26153.63.camel@cliu38-desktop-build>
References: <1381938216.26153.63.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:77V5NIzWvrmrdeAquBKyEMaBBkE70toVj+cwyAix3dh
 ZrF2Ymunn1Y19CbkNdWu47Ovl6IZcoVu/89lOItchm+2QGj5+T
 HGMBgFovKl2WY+AmEsyUSjHcBzEPh95Z3h1CrJ7YikkViWn35S
 7ni2WGUETIzcpUQeZkTL2GQdZ9dA+081bQhHB+peQPWg+koWQ6
 ysoZjeTH1ae8OFpB58ser2T2vYV3G2qAPnu3kEJtH7Y0zYoYh7
 RnTVG9VfsNcckBVnkJx6cMRCTfaUYdVmJUXLDqCvlJINGX2cCN
 Kl06NomJko3cX5T1TFKskciscuu08Z1lfhk81Jm3SfHirObaQm
 HQBDPH3LWyynZr5LMv9ZaOdvvcA3TuhTJCy2ljdz2TM+2KDTHr
 mvwz8Azv2X8qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 23:43 +0800, Chuansheng Liu wrote: 
> Meet the case that on CPU2, there are just two tasks to be run,
> one is one rt task A, another is idle task, but at this time,
> and the rt_rq is throttled.
> 
> CPU1		                 CPU2
> 				 staying in idle task;
> waking up rt task A on
> target CPU 2;
> 
>                                  exiting from idle task;
>                                  DO schedule()
>                                    pick up RT next task
> 					pick_next_task_rt()
> 						_pick_next_task_rt()
> 						rt_rq is throttled
> 					return NULL rt task to be picked
> 
> 				 CPU2 then went into idle task AGAIN;
>                                  after 2s, CPU2 is waken up again;
>                                  rt task A is get running;
> 
> Here rt task A is delayed for some time, even when CPU2 is in idle state.
> 
> so in case there are just rt tasks running, we can pick up one of them
> even rt_rq is throttled.

And shortly thereafter, a SCHED_NORMAL task wakes.. only to find that
its alleged bodyguard slit its throat while it slept.  Bad bodyguard.

-Mike


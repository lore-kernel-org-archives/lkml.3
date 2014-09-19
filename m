Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbaISLuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:50:15 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:37371 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541AbaISLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:50:12 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2014 07:50:11 EDT
Message-ID: <541C171E.6080900@bmw-carit.de>
Date: Fri, 19 Sep 2014 13:44:30 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, <peterz@infradead.org>
CC: <mingo@redhat.com>, <juri.lelli@gmail.com>, <raistlin@linux.it>,
        <michael@amarulasolutions.com>, <fchecconi@gmail.com>,
        <vincent@legout.info>, <luca.abeni@unitn.it>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] sched/deadline: clear dl_entity params when setscheduling
 to different class
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-2-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1411118561-26323-2-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/19/2014 11:22 AM, Juri Lelli wrote:
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
> 
> Reported-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
> Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

Tested-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

Fixes my problem.

Thanks,
Daniel

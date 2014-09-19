Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbaISLul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:50:41 -0400
Received: from mail.bmw-carit.de ([62.245.222.98]:37374 "EHLO
	mail.bmw-carit.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbaISLuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:50:14 -0400
Message-ID: <541C17D6.5020608@bmw-carit.de>
Date: Fri, 19 Sep 2014 13:47:34 +0200
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, <peterz@infradead.org>
CC: <mingo@redhat.com>, <juri.lelli@gmail.com>, <raistlin@linux.it>,
        <michael@amarulasolutions.com>, <fchecconi@gmail.com>,
        <vincent@legout.info>, <luca.abeni@unitn.it>,
        <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when migrating
 tasks between exclusive cpusets
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com> <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
In-Reply-To: <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/19/2014 11:22 AM, Juri Lelli wrote:
> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
> affinity (performing what is commonly called clustered scheduling).
> Unfortunately, such thing is currently broken for two reasons:
> 
>  - No check is performed when the user tries to attach a task to
>    an exlusive cpuset (recall that exclusive cpusets have an
>    associated maximum allowed bandwidth).
> 
>  - Bandwidths of source and destination cpusets are not correctly
>    updated after a task is migrated between them.
> 
> This patch fixes both things at once, as they are opposite faces
> of the same coin.
> 
> The check is performed in cpuset_can_attach(), as there aren't any
> points of failure after that function. The updated is split in two
> halves. We first reserve bandwidth in the destination cpuset, after
> we pass the check in cpuset_can_attach(). And we then release
> bandwidth from the source cpuset when the task's affinity is
> actually changed. Even if there can be time windows when sched_setattr()
> may erroneously fail in the source cpuset, we are fine with it, as
> we can't perfom an atomic update of both cpusets at once.
> 
> Reported-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

Ack

I have no special test for this, I just let my test running which was
fixed by patch #1. Works fine though. I'll plan to write some test for this.

Thanks,
Daniel

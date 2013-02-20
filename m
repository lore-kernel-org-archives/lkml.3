Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3BTKuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:50:05 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:58119 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883Ab3BTKuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:50:03 -0500
Date: Wed, 20 Feb 2013 11:49:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
Message-ID: <20130220104958.GA9152@gmail.com>
References: <51079178.3070002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51079178.3070002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Wang <wangyun@linux.vnet.ibm.com> wrote:

> v3 change log:
> 	Fix small logical issues (Thanks to Mike Galbraith).
> 	Change the way of handling WAKE.
> 
> This patch set is trying to simplify the select_task_rq_fair() 
> with schedule balance map.
> 
> After get rid of the complex code and reorganize the logical, 
> pgbench show the improvement, more the clients, bigger the 
> improvement.
> 
> 				Prev:		Post:
> 
> 	| db_size | clients |	|  tps  |	|  tps  |
>         +---------+---------+   +-------+       +-------+
>         | 22 MB   |       1 |   | 10788 |       | 10881 |
>         | 22 MB   |       2 |   | 21617 |       | 21837 |
>         | 22 MB   |       4 |   | 41597 |       | 42645 |
>         | 22 MB   |       8 |   | 54622 |       | 57808 |
>         | 22 MB   |      12 |   | 50753 |       | 54527 |
>         | 22 MB   |      16 |   | 50433 |       | 56368 |	+11.77%
>         | 22 MB   |      24 |   | 46725 |       | 54319 |	+16.25%
>         | 22 MB   |      32 |   | 43498 |       | 54650 |	+25.64%
>         | 7484 MB |       1 |   |  7894 |       |  8301 |
>         | 7484 MB |       2 |   | 19477 |       | 19622 |
>         | 7484 MB |       4 |   | 36458 |       | 38242 |
>         | 7484 MB |       8 |   | 48423 |       | 50796 |
>         | 7484 MB |      12 |   | 46042 |       | 49938 |
>         | 7484 MB |      16 |   | 46274 |       | 50507 |	+9.15%
>         | 7484 MB |      24 |   | 42583 |       | 49175 |	+15.48%
>         | 7484 MB |      32 |   | 36413 |       | 49148 |	+34.97%
>         | 15 GB   |       1 |   |  7742 |       |  7876 |
>         | 15 GB   |       2 |   | 19339 |       | 19531 |
>         | 15 GB   |       4 |   | 36072 |       | 37389 |
>         | 15 GB   |       8 |   | 48549 |       | 50570 |
>         | 15 GB   |      12 |   | 45716 |       | 49542 |
>         | 15 GB   |      16 |   | 46127 |       | 49647 |	+7.63%
>         | 15 GB   |      24 |   | 42539 |       | 48639 |	+14.34%
>         | 15 GB   |      32 |   | 36038 |       | 48560 |	+34.75%
> 
> Please check the patch for more details about schedule balance map.

The changes look clean and reasoable, any ideas exactly *why* it 
speeds up?

I.e. are there one or two key changes in the before/after logic 
and scheduling patterns that you can identify as causing the 
speedup?

Such changes also typically have a chance to cause regressions 
in other workloads - when that happens we need this kind of 
information to be able to enact plan-B.

Thanks,

	Ingo

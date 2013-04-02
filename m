Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab3DBHYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:24:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56410 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab3DBHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:24:02 -0400
Message-ID: <515A877B.3020908@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 15:23:39 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040207-0260-0000-0000-000002C007A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 11:23 AM, Alex Shi wrote:
[snip]
> 
> [patch v3 1/8] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [patch v3 2/8] sched: set initial value of runnable avg for new
> [patch v3 3/8] sched: only count runnable avg on cfs_rq's nr_running
> [patch v3 4/8] sched: update cpu load after task_tick.
> [patch v3 5/8] sched: compute runnable load avg in cpu_load and
> [patch v3 6/8] sched: consider runnable load average in move_tasks
> [patch v3 7/8] sched: consider runnable load average in
> [patch v3 8/8] sched: use instant load for burst wake up

I've tested the patch set on 12 cpu X86 box with 3.9.0-rc2, and pgbench
show regression on high-end this time.

| db_size | clients |  tps  |   |  tps  |
+---------+---------+-------+   +-------+
| 22 MB   |       1 | 10662 |   | 10446 |
| 22 MB   |       2 | 21483 |   | 20887 |
| 22 MB   |       4 | 42046 |   | 41266 |
| 22 MB   |       8 | 55807 |   | 51987 |
| 22 MB   |      12 | 50768 |   | 50974 |
| 22 MB   |      16 | 49880 |   | 49510 |
| 22 MB   |      24 | 45904 |   | 42398 |
| 22 MB   |      32 | 43420 |   | 40995 |
| 7484 MB |       1 |  7965 |   |  7376 |
| 7484 MB |       2 | 19354 |   | 19149 |
| 7484 MB |       4 | 37552 |   | 37458 |
| 7484 MB |       8 | 48655 |   | 46618 |
| 7484 MB |      12 | 45778 |   | 45756 |
| 7484 MB |      16 | 45659 |   | 44911 |
| 7484 MB |      24 | 42192 |   | 37185 |	-11.87%
| 7484 MB |      32 | 36385 |   | 34447 |
| 15 GB   |       1 |  7677 |   |  7359 |
| 15 GB   |       2 | 19227 |   | 19049 |
| 15 GB   |       4 | 37335 |   | 36947 |
| 15 GB   |       8 | 48130 |   | 46898 |
| 15 GB   |      12 | 45393 |   | 43986 |
| 15 GB   |      16 | 45110 |   | 45719 |
| 15 GB   |      24 | 41415 |   | 36813 |	-11.11%
| 15 GB   |      32 | 35988 |   | 34025 |

The reason may caused by wake_affine()'s higher overhead, and pgbench is
really sensitive to this stuff...

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


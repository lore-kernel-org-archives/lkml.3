Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaFZLaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:30:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45846 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279AbaFZLax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:30:53 -0400
Date: Thu, 26 Jun 2014 17:00:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru,
        Mike Galbraith <umgwanakikbuti@gmail.com>, khorenko@parallels.com,
        Ben Segall <bsegall@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 3/3] sched: Rework check_for_tasks()
Message-ID: <20140626113041.GD20048@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140625081502.2861.12526.stgit@tkhai>
 <1403684395.3462.44.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1403684395.3462.44.camel@tkhai>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062611-5816-0000-0000-00000EDEB117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kirill Tkhai <ktkhai@parallels.com> [2014-06-25 12:19:55]:

> 
> 1)Iterate thru all of threads in the system.
>   Check for all threads, not only for group leaders.
> 
> 2)Check for p->on_rq instead of p->state and cputime.
>   Preempted task in !TASK_RUNNING state  OR just
>   created task may be queued, that we want to be
>   reported too.
> 
> 3)Use read_lock() instead of write_lock().
>   This function does not change any structures, and
>   read_lock() is enough.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Konstantin Khorenko <khorenko@parallels.com>
> CC: Ben Segall <bsegall@google.com>
> CC: Paul Turner <pjt@google.com>
> CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> CC: Mike Galbraith <umgwanakikbuti@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
 
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju


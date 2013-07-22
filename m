Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab3GVRma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:42:30 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38095 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3GVRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:42:29 -0400
Message-ID: <1374514943.7608.25.camel@j-VirtualBox>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Jason Low <jason.low2@hp.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 10:42:23 -0700
In-Reply-To: <51EC1B38.8000708@linux.vnet.ibm.com>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <51E921EC.5040501@linux.vnet.ibm.com>
	 <1374262090.1830.16.camel@j-VirtualBox>
	 <51EC1B38.8000708@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-21 at 23:02 +0530, Preeti U Murthy wrote:
> Hi Json,
> 
> With V2 of your patch here are the results for the ebizzy run on
> 3.11-rc1 + patch on  a 1 socket, 16 core powerpc machine. Each ebizzy
> run was for 30 seconds.
> 
> Number_of_threads         %improvement_with_patch
>     4                        8.63
>     8                        1.29
>     12                       9.98
>     16                      20.46
> 
> Let me know if you want me to profile any of these runs for specific
> statistics.

Hi Preeti,

Other numbers that would be interesting to know are the % improvements
when N = 20. That is when I'm getting the bigger performance boosts on
some of the AIM7 workloads.

Would you like to re-run ebizzy with v2 of my patch except replacing
this line of code:
	if (idle_duration / 10 < (sd->avg_idle_balance_cost + cost))
with this line of code:
	if (idle_duration / 20 < (sd->avg_idle_balance_cost + cost))

Thanks a lot,
Jason


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaDODPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:15:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56421 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaDODPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:15:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534CA36D.7050708@jp.fujitsu.com>
Date: Tue, 15 Apr 2014 12:11:41 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 0/2] nohz: fix idle accounting in NO_HZ kernels
References: <53465F54.708@jp.fujitsu.com>
In-Reply-To: <53465F54.708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

(2014/04/10 18:07), Hidetoshi Seto wrote:
> Hi all,
> 
> This patch set (rebased on v3.14) is my 3rd try to fix an issue
> that idle/iowait of /proc/stat can go backward. Originally reported
> by Tetsuo and Fernando at last year, Mar 2013.
> 
> This v3 takes new approach to fix the problem, and now use seqcount
> while v1 and v2 uses seqlock.
> 
> Of course still reviews are welcome!
> 
> Thanks,
> H.Seto
> 
> Hidetoshi Seto (2):
>       nohz: stop updating sleep stats from get_cpu_{idle,iowait}_time_us()
>       nohz: use delayed iowait accounting to avoid race on idle time stats
> 
>  include/linux/tick.h     |    6 ++-
>  kernel/time/tick-sched.c |  116 ++++++++++++++++++++++++++++------------------
>  2 files changed, 74 insertions(+), 48 deletions(-)



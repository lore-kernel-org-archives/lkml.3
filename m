Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaDQJfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:35:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51166 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaDQJfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:35:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <534FA04B.8080906@jp.fujitsu.com>
Date: Thu, 17 Apr 2014 18:35:07 +0900
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
Subject: [PATCH v4 0/2] nohz: fix idle accounting in NO_HZ kernels
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set (rebased on v3.15-rc1) is my 4th try to fix an issue
that idle/iowait of /proc/stat can go backward. Originally reported
by Tetsuo and Fernando at last year, Mar 2013.

This v4 updates v3's approach, and adds description/comments to
make patch's intent to be clear (I hope so).

Of course still reviews are welcome.

Thanks,
H.Seto

Hidetoshi Seto (2):
      nohz: make updating sleep stats local
      nohz: delayed iowait accounting for nohz idle time stats

 include/linux/tick.h     |    6 +-
 kernel/time/tick-sched.c |  179 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 136 insertions(+), 49 deletions(-)



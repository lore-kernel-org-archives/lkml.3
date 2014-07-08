Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaGHILL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:11:11 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56209 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbaGHILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:11:08 -0400
Message-ID: <1404807066.26126.9.camel@x220>
Subject: Re: [PATCH tip/core/rcu 14/17] rcu: remove CONFIG_PROVE_RCU_DELAY
From: Paul Bolle <pebolle@tiscali.nl>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu,
        Andi Kleen <ak@linux.intel.com>
Date: Tue, 08 Jul 2014 10:11:06 +0200
In-Reply-To: <1404772701-8804-14-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
	 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772701-8804-14-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2014 08:11:07.0237 (UTC) FILETIME=[2B734950:01CF9A84]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, 2014-07-07 at 15:38 -0700, Paul E. McKenney wrote:
> The CONFIG_PROVE_RCU_DELAY Kconfig parameter doesn't appear to be very
> effective at finding race conditions, so this commit removes it.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/rcu/tree.c                                       | 5 -----
>  kernel/rcu/update.c                                     | 3 ---

The commit explanation implies that this patch would also remove the
entry for PROVE_RCU_DELAY in lib/Kconfig.debug. Is there any reason to
keep it after this patch?

>  tools/testing/selftests/rcutorture/configs/rcu/TREE01   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE02   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE02-T | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE03   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE04   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE05   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE06   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE07   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE08   | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE08-T | 1 -
>  tools/testing/selftests/rcutorture/configs/rcu/TREE09   | 1 -
>  13 files changed, 19 deletions(-)

This doesn't touch a few other references in
tools/testing/selftests/rcutorture/. I have no idea how these tests
work, so I assume these references are still needed. Is that correct?


Paul Bolle


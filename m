Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaFXAUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:20:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:9784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaFXAUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:20:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,533,1400050800"; 
   d="scan'208";a="562177630"
Message-ID: <53A8C44E.7050000@intel.com>
Date: Mon, 23 Jun 2014 17:20:30 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, ak@linux.intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
References: <20140621025958.GA7185@linux.vnet.ibm.com> <53A85BF9.7030006@intel.com> <53A8611F.1000804@intel.com> <20140623180945.GL4603@linux.vnet.ibm.com> <53A8B884.6000600@intel.com> <20140624001519.GO4603@linux.vnet.ibm.com>
In-Reply-To: <20140624001519.GO4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 05:15 PM, Paul E. McKenney wrote:
> Just out of curiosity, how many CPUs does your system have?  80?
> If 160, looks like something bad is happening at 80.

80 cores, 160 threads.  >80 processes/threads is where we start using
the second thread on the cores.  The tasks are also pinned to
hyperthread pairs, so they disturb each other, and the scheduler moves
them between threads on occasion which causes extra noise.

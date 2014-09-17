Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbaIQHP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 03:15:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:55485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaIQHP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 03:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="574277023"
Message-ID: <5419342E.60602@intel.com>
Date: Wed, 17 Sep 2014 15:11:42 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
CC: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
References: <20140828194745.GA3761@linux.vnet.ibm.com>
In-Reply-To: <20140828194745.GA3761@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月29日 03:47, Paul E. McKenney wrote:
> Currently, the expedited grace-period primitives do get_online_cpus().
> This greatly simplifies their implementation, but means that calls to
> them holding locks that are acquired by CPU-hotplug notifiers (to say
> nothing of calls to these primitives from CPU-hotplug notifiers) can
> deadlock.  But this is starting to become inconvenient:
> https://lkml.org/lkml/2014/8/5/754
> 
> This commit avoids the deadlock and retains the simplicity by creating
> a try_get_online_cpus(), which returns false if the get_online_cpus()
> reference count could not immediately be incremented.  If a call to
> try_get_online_cpus() returns true, the expedited primitives operate
> as before.  If a call returns false, the expedited primitives fall back
> to normal grace-period operations.  This falling back of course results
> in increased grace-period latency, but only during times when CPU
> hotplug operations are actually in flight.  The effect should therefore
> be negligible during normal operation.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Lan Tianyu <tianyu.lan@intel.com>

Hi Paul:
	What's the status of the patch? Will you push it? Thanks.

-- 
Best regards
Tianyu Lan

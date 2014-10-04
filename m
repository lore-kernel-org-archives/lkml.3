Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaJDNlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:41:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:59376 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaJDNlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:41:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,653,1406617200"; 
   d="scan'208";a="481944949"
From: Andi Kleen <andi@firstfloor.org>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slowdown due to threads bouncing between HT cores
References: <20141003194428.GA27084@sesse.net>
Date: Sat, 04 Oct 2014 06:41:15 -0700
In-Reply-To: <20141003194428.GA27084@sesse.net> (Steinar H. Gunderson's
	message of "Fri, 3 Oct 2014 21:44:29 +0200")
Message-ID: <87a95cq7es.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steinar H. Gunderson" <sgunderson@bigfoot.com> writes:
>
> So, benchmark:
>
>  - Default: 13266 kN/sec
>  - Change from ondemand to performance on all cores: 14600 kN/sec
>  - taskset -c 0-19 (locking affinity to only one set of hyperthreads):
>    17512 kN/sec

iirc the main reasons for unbound threads migrating away are:

- something else gets scheduled on these logical CPUs, so
the scheduler tries to balance to run queue lengths

You could check that with perf timechart or perf sched record/map
or kernelshark.

- there is some IO or communication which causes wakeup affinity.

You could try disabling WAKEUP_PREEMPTION or NEXT_BUDDY in 
/sys/kernel/debug/sched_features

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbaEPQG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:06:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:19384 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaEPQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1068,1389772800"; 
   d="scan'208";a="533110946"
Message-ID: <53763775.3040602@linux.intel.com>
Date: Fri, 16 May 2014 09:06:13 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        tytso@mit.edu, price@mit.edu, hannes@stressinduktion.org
Subject: Re: BUG_ON drivers/char/random.c:986 (Was: perf: use after free in
 perf_remove_from_context)
References: <5370EBE9.6@oracle.com> <20140516153455.GV11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140516153455.GV11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 08:34 AM, Peter Zijlstra wrote:
> 
> While fuzzing to reproduce my issue I hit the below, its triggered loads
> of times and then the machine wedged (needed a power cycle), I can
> provide the full console log if people care.
> 
> Anybody seen that one before?
> 

I certainly haven't... this bad.  Any idea what the actual system call
looked like?

The BUG_ON() in question indicates that r->entropy_count either
overflowed or underflowed... most likely underflowed I'd guess.

	-hpa


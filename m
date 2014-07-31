Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaGaOuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:50:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:23986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaGaOup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:50:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,772,1400050800"; 
   d="scan'208";a="569993045"
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan\, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
	<20140731072744.GN19379@twins.programming.kicks-ass.net>
Date: Thu, 31 Jul 2014 07:50:44 -0700
In-Reply-To: <20140731072744.GN19379@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 31 Jul 2014 09:27:44 +0200")
Message-ID: <8761idr397.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>
> No feedback on the correctness aspects of the overflow crap?

I assume you mean collisions? See below.

> A quick look at patch 6 reads like you still don't understand the issue
> right. There are no 'collisions' as such in PEBS record generation, or
> are there? See the earlier open discussion.

There can be collisions, but they are in practice extremely rare.

The only way you can get a lot of collision is if you count
the same thing multiple times which is not a useful configuration.
A single monitoring tool only needs a single event once.
While multiple processes may be configuring multiple events
at the same time, they will not start them at the same
time which also prevents collisions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3IETdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 15:33:19 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab3IETdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 15:33:17 -0400
Date: Thu, 5 Sep 2013 21:33:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, acme@infradead.org, jolsa@redhat.com,
        eranian@google.com
Subject: Re: perf, x86: Add parts of the remaining haswell PMU functionality
Message-ID: <20130905193315.GR19750@two.firstfloor.org>
References: <1376010946-28666-1-git-send-email-andi@firstfloor.org>
 <20130902065512.GA29060@gmail.com>
 <20130905131502.GA26387@gmail.com>
 <20130905151034.GP19750@two.firstfloor.org>
 <20130905170457.GA27741@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905170457.GA27741@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, at least the front-end side is still documented in the SDM as being 
> usable to count stalled cycles.

Stalled frontend cycles does not necessarily mean frontend bound.
The real bottleneck can be still somewhere later in the PipeLine. 
Out of Order CPUs are complex.

> 
> AFAICS backend stall cycles are documented to work on Ivy Bridge.

I'm not aware of any documentation that presents these events
as accurate frontend/backend stalls without using the full
TopDown methology (Optimization manual B.3.2)

The level 1 top down method for IvyBridge and Haswell is:

PipelineWidth = 4
Slots = PipelineWidth*CPU_CLK_UNHALTED
FrontendBound = IDQ_UOPS_NOT_DELIVERED.CORE / Slots
BadSpeculation = (UOPS_ISSUED.ANY - UOPS_RETIRED.RETIRE_SLOTS +
Width*INT_MISC.RECOVERY_CYCLES) / Slots
Retiring = UOPS_RETIRED.RETIRE_SLOTS / Slots
BackendBound = FrontendBound - BadSpeculation + Retiring

> For perf stat -a alike system-wide workloads it should still produce 
> usable results that way.

For some classes of workloads it will be a large unpredictable
systematic error.

> I.e. something like the patch below (it does not solve the double counting 
> yet).

Well you can add it, but I'm not going to Ack it.

-Andi


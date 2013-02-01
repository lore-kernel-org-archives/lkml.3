Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3BAKQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:16:36 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43556 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3BAKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:16:33 -0500
Date: Fri, 1 Feb 2013 11:16:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 04/12] perf, x86: Support the TSX intx/intx_cp qualifiers
 v3
Message-ID: <20130201101628.GB23061@gmail.com>
References: <1359672710-19528-1-git-send-email-andi@firstfloor.org>
 <1359672710-19528-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359672710-19528-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Implement the TSX transaction and checkpointed transaction qualifiers for
> Haswell. This allows e.g. to profile the number of cycles in transactions.
> 
> The checkpointed qualifier requires forcing the event to
> counter 2, implement this with a custom constraint for Haswell.
> 
> Also add sysfs format attributes for intx/intx_cp

The series is getting smaller, but you still included this patch 
I pointed out in my last review, which unnecessary increases the 
size of the initial hw support series by adding Haswell-specific 
transaction profiling features.

As requested before, please keep those in a completely separate 
series so that minimal support can be merged upstream. This is 
how we always did new hardware support in the past, in iterative 
steps, and we are not going to make an exception for you.

I find it pretty counterproductive that you have ignored my 
previous series structure request. Every unnecessary delay you 
cause here delays upstream profiling support for Haswell CPUs.

Thanks,

	Ingo

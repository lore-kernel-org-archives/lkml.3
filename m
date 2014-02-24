Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaBXNKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:10:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36898 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaBXNKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:10:30 -0500
Date: Mon, 24 Feb 2014 14:10:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: hang in migrate_swap
Message-ID: <20140224131025.GG3104@twins.programming.kicks-ass.net>
References: <5304F32A.4040907@oracle.com>
 <5305856F.3000109@linux.vnet.ibm.com>
 <53078241.3060201@oracle.com>
 <53080122.609@linux.vnet.ibm.com>
 <530ABB44.5000601@oracle.com>
 <530AD653.3000808@linux.vnet.ibm.com>
 <20140224071028.GW9987@twins.programming.kicks-ass.net>
 <530B1B80.4000307@linux.vnet.ibm.com>
 <20140224121218.GR15586@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224121218.GR15586@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 01:12:18PM +0100, Peter Zijlstra wrote:
> +		if (p) {
> +			if (unlikely(p == RETRY_TASK))
> +				goto again;

We could even make that: unlikely(p & 1), I think most CPUs can encode
that far better than the full pointer immediate.

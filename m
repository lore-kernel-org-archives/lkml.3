Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3HOKSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:18:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49133 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3HOKSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:18:30 -0400
Date: Thu, 15 Aug 2013 12:18:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/4] perf, tools: Add perf stat --transaction v3
Message-ID: <20130815101819.GM24092@twins.programming.kicks-ass.net>
References: <1376505267-8902-1-git-send-email-andi@firstfloor.org>
 <1376505267-8902-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376505267-8902-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 11:34:27AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add support to perf stat to print the basic transactional execution statistics:
> Total cycles, Cycles in Transaction, Cycles in aborted transsactions
> using the in_tx and in_tx_checkpoint qualifiers.
> Transaction Starts and Elision Starts, to compute the average transaction length.
> 
> This is a reasonable overview over the success of the transactions.
> 
> Enable with a new --transaction / -T option.
> 
> This requires measuring these events in a group, since they depend on each
> other.
> 
> This is implemented by using TM sysfs events exported by the kernel
> 
> v2: Only print the extended statistics when the option is enabled.
> This avoids negative output when the user specifies the -T events
> in separate groups.
> v3: Port to latest tree
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/Documentation/perf-stat.txt |   5 ++
>  tools/perf/builtin-stat.c              | 132 ++++++++++++++++++++++++++++++++-
>  tools/perf/util/evsel.h                |   6 ++
>  tools/perf/util/pmu.c                  |  16 ++++
>  tools/perf/util/pmu.h                  |   1 +
>  5 files changed, 157 insertions(+), 3 deletions(-)

Arnaldo, ACK on this?

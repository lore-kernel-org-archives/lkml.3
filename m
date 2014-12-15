Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbaLOPS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:18:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLOPSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:18:20 -0500
Date: Mon, 15 Dec 2014 16:18:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com
Subject: Re: [PATCH 1/1] perf, x86: bug fix for cycles:p and cycles:pp on SLM
Message-ID: <20141215151807.GA29390@twins.programming.kicks-ass.net>
References: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418048863-4294-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 06:27:43AM -0800, kan.liang@intel.com wrote:
> From: Kan Liang <kan.liang@intel.com>
> 
> cycles:p and cycles:pp don't work on SLM since 86a0446

The canonical format for referencing commits is:
  86a04461a99f ("perf/x86: Revamp PEBS event selection")

> This regression issue is because UOPS_RETIRED.ALL is not a PEBS event on SLM.

Nor is it actually the alias used, afaict SLM uses
intel_pebs_aliases_core2().

> According to pebs_aliases, INST_RETIRED.ANY_P (a PEBS capable event) can be
> used as an alternative way to count cycles. Roll back the pebs_constraints to
> use INST_RETIRED.ANY_P.

Furthermore the counter mask of 0xf seems wrong too, and you've indeed
corrected that too (to 0x01, seeing how the SLM only has PEBS on cnt0).

Fixes: 86a04461a99f ("perf/x86: Revamp PEBS event selection")
> Signed-off-by: Kan Liang <kan.liang@intel.com>

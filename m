Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaHEVhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:37:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:52455 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaHEVhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:37:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,807,1400050800"; 
   d="scan'208";a="465332330"
Date: Tue, 5 Aug 2014 14:37:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: [PATCH] perf/x86: fix load latency/precise store data source
 issues
Message-ID: <20140805213734.GI5803@tassilo.jf.intel.com>
References: <20140805041333.GA17598@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805041333.GA17598@quad>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 06:13:33AM +0200, Stephane Eranian wrote:
> 
> This patch fixes some issues introduced by Andi's 'Revamp
> PEBS' event selection patch (which is under review right now).
> 
> Most of the issues were related to the encoding of the
> data source, for PEBS events in general and load/store
> events on Haswell.
> 
> This patchd does:
>  - the default of 0 in perf_sample_data_init() was wrong. 0 is not
>   a valid value. So defined PERF_MEM_NA (not available)

Looks good.

> 
>  - On HSW, renamed your precise_store_hsw() to datala_hsw()
>    because you are actually processing both loads and stores, except
>    the load latency event which goes thru normal function

Pleae don't mix cleanups with bug fixes.

> 
>  - precise_store_data_hsw() was returning bogus data source for store
>    events. dse.mem_lvl instead of dse.val

This was already fixed in the second patch (and it wasn't introduced
by my patch):

commit 57f6c0e81f5b82b341c4c4ddd621531788c50433
Author: Andi Kleen <ak@linux.intel.com>
Date:   Fri Jul 18 17:41:48 2014 -0700

    perf, x86: Fix haswell mem hierarchy flags reporting
    
    This fixes a bug introduced with
    
    commit 722e76e60f2775c21b087ff12c5e678cf0ebcaaf
    Author: Stephane Eranian <eranian@google.com>
    Date:   Thu May 15 17:56:44 2014 +0200
    
        fix Haswell precise store data source encoding
    
    When returning early we need to return the complete value of the
    memory hierarchy, not just the mem_lvl. Otherwise any load/store/na
    flags set early get lost.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

-Andi



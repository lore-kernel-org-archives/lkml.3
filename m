Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaCNNyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:54:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:18666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaCNNym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:54:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,655,1389772800"; 
   d="scan'208";a="499876462"
Date: Fri, 14 Mar 2014 06:54:39 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH 1/2] perf, x86: Disallow setting undefined bits for PEBS
 events
Message-ID: <20140314135439.GD3793@tassilo.jf.intel.com>
References: <1394745733-27855-1-git-send-email-andi@firstfloor.org>
 <20140314081338.GL27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314081338.GL27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:13:38AM +0100, Peter Zijlstra wrote:
> On Thu, Mar 13, 2014 at 02:22:12PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The SDM forbids setting various event qualifiers with PEBS
> > events. The magic cycles:pp event uses it, but it has caused
> > problems in the past. We continue allowing it for cycles:pp,
> > but forbid it for all other events to follow the SDM.
> 
> Last time this came up I asked for what kind of problems it caused.

The original PEBS lockup on Sandy Bridge was caused by these bits.
The person who architected the hardware strongly advised to not
use them with PEBS events. 

Besides we do what the SDM tells us to do. Do you disagree
with that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

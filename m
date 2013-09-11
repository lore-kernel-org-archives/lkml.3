Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3IKQuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:50:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:53908 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab3IKQuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="293613536"
Date: Wed, 11 Sep 2013 09:50:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        zheng.z.yan@intel.com, dhsharp@google.com
Subject: Re: [PATCH] perf,x86: add constraint for IVB
 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
Message-ID: <20130911165018.GJ11427@tassilo.jf.intel.com>
References: <20130911152222.GA28761@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911152222.GA28761@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:22:22AM -0700, Stephane Eranian wrote:
> 
> The IvyBridge event CYCLE_ACTIVITY:CYCLES_LDM_PENDING can only
> be measured on counters 0-3 when HT is off. When HT is on, you
> only have counters 0-3.
> 
> If you program it on the eight counters for 1s on a 3GHz
> IVB laptop running a noploop, you see:
> 
>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>            2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
>        3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
> 
> Clearly the last 4 values are bogus.

Thanks looks good.

Likely need it on Haswell too?

-Andi

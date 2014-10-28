Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaJ1NLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:11:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:15968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaJ1NLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407241401"
Date: Tue, 28 Oct 2014 06:10:55 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx@linutronix.de, eranian@google.com,
        dzickus@redhat.com, andi@firstfloor.org, jmario@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf,x86: Add HSW offcore NUMA events
Message-ID: <20141028131055.GI3274@tassilo.jf.intel.com>
References: <20141028123043.257488788@infradead.org>
 <20141028123352.632326435@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028123352.632326435@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:30:46PM +0100, Peter Zijlstra wrote:
> Based on the actual HSW offcore bits, we can construct the full NODE
> event set in a similar manner to the other uarchs (NHM/SNB).

The better way is to use
MEM_LOAD_UOPS_LLC_MISS_RETIRED.LOCAL_DRAM
MEM_LOAD_UOPS_LLC_MISS_RETIRED.REMOTE_DRAM

directly. These support PEBS too and have various other advantages.

-Andi

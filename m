Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaFSSCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:02:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:57256 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933226AbaFSSCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:02:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="560300359"
Date: Thu, 19 Jun 2014 11:00:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jmario@redhat.com, dzickus@redhat.com, jolsa@redhat.com,
        acme@redhat.com
Subject: Re: [PATCH 1/2] perf/x86: update Haswell PEBS event constraints
Message-ID: <20140619180028.GU8178@tassilo.jf.intel.com>
References: <1403193509-22393-1-git-send-email-eranian@google.com>
 <1403193509-22393-2-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403193509-22393-2-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 05:58:28PM +0200, Stephane Eranian wrote:
> The following events support PEBS for all umasks,
> thus use INTEL_EVENT_CONSTRAINT() instead of
> INTEL_UEVENT_CONSTRAINT():
> 
> 0xd1 MEM_LOAD_UOPS_RETIRED
> 0xd2 MEM_LOAD_UOPS_LLC_HIT_RETIRED
> 0xd3 MEM_LOAD_UOPS_LLC_MISS_RETIRED
> 
> For event 0xd0 (MEM_UOPS_RETIRED), the same is true, except
> we need to distinguish precise store (umask 0x82) from load
> latency events, thus we keep the breakdown per umask. But all
> umasks do support PEBS.

I sent a similar patch some time ago

http://lkml.iu.edu/hypermail/linux/kernel/1404.2/01509.html

However these days I'm actually thinking of just getting
rid of the detailed table except for PREC_DIST. All the PEBS
controls should be noops if the event does not support PEBS

-Andi

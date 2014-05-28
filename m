Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaE1QwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:52:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:17977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbaE1QwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:52:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="539033372"
Date: Wed, 28 May 2014 09:51:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [RFC PATCH 6/7] perf, x86: large PEBS interrupt threshold
Message-ID: <20140528165144.GK29957@tassilo.jf.intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
 <1401257890-30535-7-git-send-email-zheng.z.yan@intel.com>
 <20140528081053.GP11096@twins.programming.kicks-ass.net>
 <20140528145831.GH29957@tassilo.jf.intel.com>
 <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQZWC33egtrpGLUHKizzrFRAz68-AsP-GWxB=Q--bjf8g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only part I don't quite follow here is this:
>                       if (__test_and_set_bit(bit, (unsigned long *)&status))
>                                 continue;
> 
> Which seems to indicate the code is making sure each counter is
> processed only once. But it can only be processed once, if you have
> only one record. And if you have multiple, you want to be able to
> handle the same counter multiple times, at least once perf PEBS
> record. So I am a bit confused about this test.

Each PEBS record is only for a single counter overflow. So it
always should only be a single perf event.

-Andi

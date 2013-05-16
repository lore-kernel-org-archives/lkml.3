Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3EPQH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:07:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:23413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab3EPQH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,684,1363158000"; 
   d="scan'208";a="314712739"
Date: Thu, 16 May 2013 09:07:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
Message-ID: <20130516160721.GP4072@tassilo.jf.intel.com>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.083340271@chello.nl>
 <20130503143507.GP19487@tassilo.jf.intel.com>
 <20130503170007.GA30733@dyad.programming.kicks-ass.net>
 <CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
 <20130515165152.GB13916@laptop.home>
 <CABPqkBSrLdXrg+p_A537O1mkv8Ewm-qt+0ugWOwJvLa6yn9ERg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSrLdXrg+p_A537O1mkv8Ewm-qt+0ugWOwJvLa6yn9ERg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The difficulty is that we cannot use the shared_regs infrastructure because
> the constraint is quite different. Here we need to say that if a mem event
> uses cnt0 on one thread, then nothing can be using cnt0 on the other thread.
> The current shared_regs infrastructure does not work on the counter level.
> So we need to invent something else. It cannot even be extended.

Just need a extra reg per counter, that is only triggered with that event.

-Andi

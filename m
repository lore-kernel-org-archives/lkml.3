Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3IJPfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:35:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3IJPfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:35:13 -0400
Date: Tue, 10 Sep 2013 17:35:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130910153500.GJ31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
 <522F3ACC.9000701@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522F3ACC.9000701@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 08:29:16AM -0700, Arjan van de Ven wrote:

> also.. yuck on using "dec" "dec" sucks, please use "sub foo  ,1"
> instead (dec sucks because of its broken flags behavior; it creates
> basically a bubble in the pipeline)

Then someone needs to go change:

  atomic{,64}_dec*()
  local{,64}_dec*()
  percpu_add_op()

All of which use decl/incl, percpu_add_op() actually goes out of its way
to generate them.

Also, subl ,1 is 4 bytes larger.

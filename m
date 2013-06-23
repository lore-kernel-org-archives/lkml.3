Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3FWSGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 14:06:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3FWSGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 14:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,923,1363158000"; 
   d="scan'208";a="334262308"
Date: Sun, 23 Jun 2013 11:06:05 -0700
From: Andi Kleen <ak@linux.jf.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
Subject: Re: Oops in ring_buffer_alloc_read_page()
Message-ID: <20130623180605.GM5643@tassilo.jf.intel.com>
References: <20130618120855.GA29700@localhost>
 <1371737149.18733.92.camel@gandalf.local.home>
 <20130623042528.GA20094@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623042528.GA20094@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good question! I tried disabling CPA self-test and the BUG does not
> show up for 10000 boots. So this should be the root cause.
> 

The test is very different now than what I wrote originally, but I would
generally expect any bug to be in change_page_attr(), not be in the
self test.

> > > [   36.776024] *pde = 0e3e1067 *pte = 061e7260 

The oops is in a 2MB page that should not have changed by CPA 
in theory (it just adds 4KB pages)

I suppose you could log the addresses touched by the test and compare
to the oops addresses.

Most likely the reason you don't see it all the time is that the 
test is randomized. So you could make it more stable by fixing
the seed in pageattr-test and perhaps changing it to use more
pages.

> > > [   36.776024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007

Could be also some virtualization problem?

-andi

-- 
ak@linux.intel.com -- Speaking for myself only

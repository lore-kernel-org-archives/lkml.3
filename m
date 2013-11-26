Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3KZI0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:26:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40520 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3KZI0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:26:39 -0500
Date: Tue, 26 Nov 2013 09:26:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "ccross@google.com" <ccross@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: Re: Add memory barrier when waiting on futex
Message-ID: <20131126082626.GB789@laptop.programming.kicks-ass.net>
References: <3917C05D9F83184EAA45CE249FF1B1DD0252FAEA@SHSMSX103.ccr.corp.intel.com>
 <20131125143952.GB10022@twins.programming.kicks-ass.net>
 <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0252FBF3@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 01:07:25AM +0000, Ma, Xindong wrote:
> I've already aware that they've protected by spinlock, this is why I adding a memory barrier to fix it.

That doesn't make sense.. the spinlocks should provide the required
serialization, there's nothing to fix.

> I reproduced this issue several times on android which running on IA dual core.

I think you need to be more specific, in particular, if spinlocks do not
provide serialization on your IA32 device, I'd call that thing broken.
Adding random memory barriers is _WRONG_.



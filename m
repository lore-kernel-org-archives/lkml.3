Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab3BLKLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:11:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3BLKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:11:36 -0500
Message-ID: <1360663879.4485.2.camel@laptop>
Subject: Re: [patch v4 01/18] sched: set SD_PREFER_SIBLING on MC domain to
 reduce a domain level
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:11:19 +0100
In-Reply-To: <1358996820-23036-2-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> The domain flag SD_PREFER_SIBLING was set both on MC and CPU domain at
> frist commit b5d978e0c7e79a, and was removed uncarefully when clear up
> obsolete power scheduler. Then commit 6956dc568 recover the flag on CPU
> domain only. It works, but it introduces a extra domain level since this
> cause MC/CPU different.
> 
> So, recover the the flag in MC domain too to remove a domain level in
> x86 platform.

This fails to clearly state why its desirable.. I'm guessing its because
we should use sibling cache domains before sibling threads, right?

A clearly stated reason is always preferable over: it was this way, make
it so again; which leaves us wondering why. 


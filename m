Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaIXHsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:48:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:38381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIXHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:48:00 -0400
Date: Wed, 24 Sep 2014 09:47:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, x86: Disallow flags for most
 Core2/Atom/Nehalem/Westmere events
Message-ID: <20140924074753.GR16043@twins.programming.kicks-ass.net>
References: <1411509264-18135-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411509264-18135-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:54:24PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Disallow setting inv/cmask/etc. flags for all PEBS events
> on these CPUs, except for the UOPS_RETIRED.* events on Nehalem/Westmere,
> which are needed for cycles:p. This avoids an undefined situation
> strongly discouraged by the Intle SDM. The PLD_* events were already
> covered. This follows the earlier changes for Sandy Bridge and alter.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

>From the compile before sending dept:

../arch/x86/kernel/cpu/perf_event_intel_ds.c:555:2: error: implicit declaration of function ‘INTEL_FLAGS_UEVENT_CONSTRAINT’ [-Werror=implicit-function-declaration]


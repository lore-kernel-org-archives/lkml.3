Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3IPQDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:03:16 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37396 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3IPQDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:03:13 -0400
Date: Mon, 16 Sep 2013 18:03:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel: Clean-up/reduce PEBS code
Message-ID: <20130916160311.GW18242@two.firstfloor.org>
References: <tip-8q6y4davda9aawwv5yxe7klp@git.kernel.org>
 <87mwng53ki.fsf@tassilo.jf.intel.com>
 <20130916060736.GN21832@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916060736.GN21832@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There already was an implicit division there, and
> sizeof(pebs_record_hsw) = 176, can it really optimize that constant
> division?

Yes it can (if nothing else then by converting it to * 1/x)

The only exception is with -Os, but if you want performance
you should not be using that anyways.

You could do that manually, but it's easiest to just keep
the code paths separate and let the compiler worry about it.

> I suppose we could go and introduce CONFIG_PERF_DEBUG and stuff sanity
> checks under that.. :/

Hmm, it's not a sanity check?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

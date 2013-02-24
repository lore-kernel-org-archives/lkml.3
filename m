Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab3BXMHc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:07:32 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53649 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab3BXMHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:07:30 -0500
Date: Sun, 24 Feb 2013 13:07:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] perf, x86: Support full width counting v3
Message-ID: <20130224120726.GB20905@gmail.com>
References: <1361213287-7636-1-git-send-email-andi@firstfloor.org>
 <1361213287-7636-5-git-send-email-andi@firstfloor.org>
 <20130222134630.GA8960@gmail.com>
 <20130222151950.GK2928@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222151950.GK2928@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Recent Intel CPUs like Haswell and IvyBridge have a new 
> alternative MSR range for perfctrs that allows writing the 
> full counter width. Enable this range if the hardware reports 
> it using a new capability bit.
> 
> This lowers the overhead of perf stat slightly because it has
> to do less interrupts to accumulate the counter value. On
> Haswell it also avoids some problems with TSX aborting when
> the end of the counter range is reached.
>
> This can be observed when the checkpoint flag has been set, 
> which has been enabled by the basic PMU patch. An overflow 
> will abort the transaction and set the counter back. If the 
> counter is near the overflow before the transaction this could 
> happen continuously, forcing a transaction to continuously 
> abort.
>
> This is a partial fix, but it makes the overflows much less 
> likely by using a larger counter, to lower the probability of 
> the event. Additional counter measures are in the additional 
> extended Haswell patchkit.

It would actually be _much_ more useful to first try to fix that 
condition - then extend the counter range. As you say it in the 
changelog it can happen anyway: and it's much more testable if 
the counter width is narrower initially.

Mind restructuring the basic patches thusly, putting the fix 
first and moving the counter extension to the later patches?

(If you don't have the time for that we can delay it all to 
v3.10, it's pretty late already even for v3.9.)

Thanks,

	Ingo

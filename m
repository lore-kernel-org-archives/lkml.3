Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab3FYHWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:22:17 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64508 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3FYHWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:22:16 -0400
Date: Tue, 25 Jun 2013 09:22:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, peterz@infradead.org,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: Re: [PATCH] perf, x86: Support full width counting v3
Message-ID: <20130625072212.GA11420@gmail.com>
References: <1372121749-12164-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372121749-12164-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Recent Intel CPUs like Haswell and IvyBridge have a new alternative MSR
> range for perfctrs that allows writing the full counter width. Enable this
> range if the hardware reports it using a new capability bit.
> 
> This lowers the overhead of perf stat slightly because it has to do less
> interrupts to accumulate the counter value. On Haswell it also avoids some
> problems with TSX aborting when the end of the counter range is reached.

Looks good - the changelog needs more work: please first outline the 
current behavior (how we can only write 32 bit values into the counter, 
even though the counter range is larger on most CPUs).

Then also outline the Haswell problems more precisely. What happens, why, 
with what probability and why do we care?

Thanks,

	Ingo

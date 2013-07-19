Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab3GSJEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:04:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54007 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822Ab3GSJEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:04:31 -0400
Date: Fri, 19 Jul 2013 10:03:28 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 02/17] sched_clock: Use seqcount instead of rolling
 our own
Message-ID: <20130719090328.GA18139@mudshark.cambridge.arm.com>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <1374189690-10810-3-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374189690-10810-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 12:21:15AM +0100, Stephen Boyd wrote:
> We're going to increase the cyc value to 64 bits in the near
> future. Doing that is going to break the custom seqcount
> implementation in the sched_clock code because 64 bit numbers
> aren't guaranteed to be atomic. Replace the cyc_copy with a
> seqcount to avoid this problem.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  kernel/time/sched_clock.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)

Looks good to me. The current scheme would be very fiddly to extend to
64-bit values on 32-bit architectures without cheap atomic doubleword
accesses.

Acked-by: Will Deacon <will.deacon@arm.com>

Will

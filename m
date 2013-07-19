Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239Ab3GSO1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:27:38 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37628 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSO1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:27:37 -0400
Date: Fri, 19 Jul 2013 15:27:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 02/17] sched_clock: Use seqcount instead of rolling
	our own
Message-ID: <20130719142718.GG24642@n2100.arm.linux.org.uk>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-3-git-send-email-sboyd@codeaurora.org> <20130719090328.GA18139@mudshark.cambridge.arm.com> <alpine.LFD.2.03.1307191016010.14924@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1307191016010.14924@syhkavp.arg>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 10:20:19AM -0400, Nicolas Pitre wrote:
> On Fri, 19 Jul 2013, Will Deacon wrote:
> 
> > Looks good to me. The current scheme would be very fiddly to extend to
> > 64-bit values on 32-bit architectures without cheap atomic doubleword
> > accesses.
> 
> You should have a look at include/linux/cnt32_to_63.h.
> This could be applied to pure software counters if the low part is 
> atomically increased.

But this can't be used for sched_clock().  That's exactly why I originally
had to rewrite that thing in the first place.

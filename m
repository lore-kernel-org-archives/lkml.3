Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751Ab3GSOU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 10:20:27 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60012 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3GSOUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 10:20:22 -0400
Date: Fri, 19 Jul 2013 10:20:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Will Deacon <will.deacon@arm.com>
cc: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
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
In-Reply-To: <20130719090328.GA18139@mudshark.cambridge.arm.com>
Message-ID: <alpine.LFD.2.03.1307191016010.14924@syhkavp.arg>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-3-git-send-email-sboyd@codeaurora.org> <20130719090328.GA18139@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Will Deacon wrote:

> Looks good to me. The current scheme would be very fiddly to extend to
> 64-bit values on 32-bit architectures without cheap atomic doubleword
> accesses.

You should have a look at include/linux/cnt32_to_63.h.
This could be applied to pure software counters if the low part is 
atomically increased.


Nicolas

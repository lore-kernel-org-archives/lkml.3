Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaEHKZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:25:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60979 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbaEHKZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:25:45 -0400
Date: Thu, 8 May 2014 11:25:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: enable context tracking
Message-ID: <20140508102514.GA6942@arm.com>
References: <1399419149-26685-1-git-send-email-larry.bassel@linaro.org>
 <1399419149-26685-3-git-send-email-larry.bassel@linaro.org>
 <20140507101709.GE18456@arm.com>
 <7hr445w3nz.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hr445w3nz.fsf@paris.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 12:49:04AM +0100, Kevin Hilman wrote:
> Hi Will,

Hello Kevin,

> Will Deacon <will.deacon@arm.com> writes:
> > On Wed, May 07, 2014 at 12:32:29AM +0100, Larry Bassel wrote:
> >> Make calls to ct_user_enter when the kernel is exited
> >> and ct_user_exit when the kernel is entered (in el0_da,
> >> el0_ia, el0_svc, el0_irq).
> >
> > Why only these entry points? I can reschedule after any exception from EL0,
> > so I'd expect all exceptions from userspace to need annotating, no?
> 
> In my initial approach to this, you might recall (though it was over a
> year ago now) was to just instrument kernel_enter rather than sprinkle
> the instrumentaion in cl0_*.  However, your concern at the time was that
> since it was before debugging was enabled it would complicate debugging
> these paths.
> 
> Any chance you have any other suggestion on how we might do this in
> kernel_entry rather than sprinkling them all over cl0_*?  or is the
> sprinkling the only good way to handle this.

Unfortunately, different exceptions do subtly different things before
invoking the main handler. For example:

 - Stashing the far
 - Enabling IRQs
 - Enabling debug
 - All the stuff on the syscall path

so putting the logic in kernel_entry isn't really do-able, unfortunately.

Will

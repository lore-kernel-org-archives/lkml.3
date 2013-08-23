Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3HWJ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:26:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60732 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108Ab3HWJ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:26:46 -0400
Date: Fri, 23 Aug 2013 10:26:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 0/6] ARM/ARM64 architected timer updates
Message-ID: <20130823092610.GB20186@darko.cambridge.arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <5213A40C.6060509@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5213A40C.6060509@arm.com>
Thread-Topic: [PATCH v3 0/6] ARM/ARM64 architected timer updates
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 06:14:52PM +0100, Sudeep KarkadaNagesha wrote:
> On 13/08/13 18:29, Sudeep KarkadaNagesha wrote:
> > From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> > 
> > This patch series adds support to configure the rate and enable the
> > event stream for architected timer. The event streams can be used to
> > impose a timeout on a WFE, to safeguard against any programming error
> > in case an expected event is not generated or even to implement
> > wfe-based timeouts for userspace locking implementations.
> > 
> > Since the timer control register is reset to zero on warm boot, CPU
> > PM notifier is added to re-initialize it.
> > 
> > Changes v2->v3:
> > 1. Moved ARM and ARM64 changes into separate patches
> > 2. Added native hwcaps definations(ARM/ARM64) and compat-specific
> >    definitions(ARM64) to the users for the event stream feature. 
> 
> Can you review this version of the series ?

I think the series is OK with the follow-up comments addressed. Could
you please post a v4 to make sure I haven't missed anything?

Another comment I have is whether we should make this feature
configurable. The reason is mainly hardware validation: if some CPU
implementation messes the event generation (and on ARMv8 it's a bit more
complex as this is tied to the exclusive monitor) we risk not detecting
it because of the event stream.

Thanks.

-- 
Catalin

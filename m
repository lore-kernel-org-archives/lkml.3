Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3KRRYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:24:47 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50694 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751338Ab3KRRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:24:40 -0500
Date: Mon, 18 Nov 2013 17:23:48 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
Message-ID: <20131118172347.GE9838@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <528A47B0.1090800@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528A47B0.1090800@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:00:32PM +0000, Stephen Warren wrote:
> On 11/17/2013 08:59 AM, Catalin Marinas wrote:
> > On 17 November 2013 08:49, Alexandre Courbot <acourbot@nvidia.com> wrote:
> >> The ARM tree includes a firmware_ops interface that is designed to
> >> implement support for simple, TrustZone-based firmwares but could
> >> also cover other use-cases. It has been suggested that this
> >> interface might be useful to other architectures (e.g. arm64) and
> >> that it should be moved out of arch/arm.
> > 
> > NAK. I'm for code sharing with arm via common locations but this API
> > goes against the ARMv8 firmware standardisation efforts like PSCI,
> > encouraging each platform to define there own non-standard interface.
> 
> Surely PSCI is *an* implementation of firmware_ops?
> 
> Couldn't firmware_ops be relevant to non-ARM architectures too?

There are similarities but you don't ask other architectures to
implement an l2x0_init function. If we find other things we want to
describe in here, does this structure become a pool of function pointers
to be shared by other architectures? What's the common functionality
that you want to place in this structure?

> If so, that would support my previous point; we're presumably not
> requiring non-ARM architectures to implement PSCI?

So you think non-ARM architectures could make use of the firmware_ops?

> On a practical note, unless ARM mandates by ARM architecture licensing
> condition that mechanisms other than PSCI are not allowed, then they're
> going to exist even if the upstream Linux community doesn't like it.
> History has certainly shown that.

I'm pretty sure they will exist, as there is tons of kernel code in
production devices that never reach mainline. And I already stated a few
times, this interface can be extended, I just don't want one per SoC
just because some vendors want to use different SMC numbers.

-- 
Catalin

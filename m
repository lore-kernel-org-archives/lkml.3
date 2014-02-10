Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaBJQ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:29:13 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51636 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752606AbaBJQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:29:08 -0500
Date: Mon, 10 Feb 2014 16:28:22 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonathan Austin <Jonathan.Austin@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "ben.dooks@codethink.co.uk" <ben.dooks@codethink.co.uk>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "maxime.coquelin@st.com" <maxime.coquelin@st.com>
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140210162822.GF2794@e103592.cambridge.arm.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
 <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
 <20140207170903.GT5976@mudshark.cambridge.arm.com>
 <52F892C8.80508@st.com>
 <20140210111710.GC17766@mudshark.cambridge.arm.com>
 <20140210135659.GU26684@n2100.arm.linux.org.uk>
 <20140210144228.GC2794@e103592.cambridge.arm.com>
 <20140210151934.GZ26684@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210151934.GZ26684@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:19:34PM +0000, Russell King - ARM Linux wrote:
> On Mon, Feb 10, 2014 at 02:42:28PM +0000, Dave Martin wrote:
> > Should we require CPSR.A to me masked in Booting, for all CPUs that have
> > it?
> 
> If it's not masked at boot, then there can't be an imprecise exception
> pending.

Couldn't there still be a dangling abort condition triggered by the
bootloader, which which doesn't raise the abort pin until after we
entered the kernel?

> That's unlike interrupts, where a device could trigger an interrupt at
> any moment (eg, a timer expiring.)


List as with interrupts, there's no way to drain or cancel pending aborts
that aren't asserted yet, but whose cause conditions are already
established.

It's possible that Strongly-Ordered memory is sufficient to
guarantee that any D-side abort becomes synchronous in some
implementations but I don't think the arhitecture guarantees it.

It certainly won't be guaranteed for any other memory type.


For these reasons, imprecise aborts seem a lot like interrupts:
you can mask them or handle them; but controlling when and whether
they occur involves platform-specific assumptions, at least in
theory.

Cheers
---Dave

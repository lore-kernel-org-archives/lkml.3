Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaBJQhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:37:19 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60192 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751920AbaBJQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:37:15 -0500
Date: Mon, 10 Feb 2014 16:37:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <Dave.Martin@arm.com>
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
Message-ID: <20140210163700.GD26684@n2100.arm.linux.org.uk>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140207170903.GT5976@mudshark.cambridge.arm.com> <52F892C8.80508@st.com> <20140210111710.GC17766@mudshark.cambridge.arm.com> <20140210135659.GU26684@n2100.arm.linux.org.uk> <20140210144228.GC2794@e103592.cambridge.arm.com> <20140210151934.GZ26684@n2100.arm.linux.org.uk> <20140210162822.GF2794@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210162822.GF2794@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:28:22PM +0000, Dave Martin wrote:
> On Mon, Feb 10, 2014 at 03:19:34PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Feb 10, 2014 at 02:42:28PM +0000, Dave Martin wrote:
> > > Should we require CPSR.A to me masked in Booting, for all CPUs that have
> > > it?
> > 
> > If it's not masked at boot, then there can't be an imprecise exception
> > pending.
> 
> Couldn't there still be a dangling abort condition triggered by the
> bootloader, which which doesn't raise the abort pin until after we
> entered the kernel?

True, but the decompressor does disable them (see safe_svcmode_maskall),
so any raised abort is likely to hit the boot loader's vectors at that
time.  They remain masked into the kernel from that point.

If you're not using the decompressor then the A bit will be left as-is.

Given that we've not yet had any failures, I'm inclined to just let the
status-quo be for the kernel entry - if it does cause problems then it's
clear that the right solution is that the A bit must be disabled.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

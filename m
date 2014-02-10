Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBJPWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:22:39 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51561 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751770AbaBJPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:22:36 -0500
Date: Mon, 10 Feb 2014 15:21:47 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux@arm.linux.org.uk, jonathan.austin@arm.com, nico@linaro.org,
        marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, vgupta@synopsys.com,
        u.kleine-koenig@pengutronix.de,
        Fabrice GASNIER <fabrice.gasnier@st.com>, sboyd@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, maxime.coquelin@st.com
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140210152147.GE2794@e103592.cambridge.arm.com>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com>
 <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com>
 <20140210141634.GA2794@e103592.cambridge.arm.com>
 <52F8E81E.70804@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8E81E.70804@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:54:22PM +0000, Ben Dooks wrote:
> On 10/02/14 14:16, Dave Martin wrote:
> >On Fri, Feb 07, 2014 at 05:19:15PM +0100, Fabrice GASNIER wrote:
> >>This patch adds imprecise abort enable/disable macros.
> >>It also enables imprecise aborts when starting kernel.
> >
> >Relying on imprecise aborts for hardware probing would be considered bad
> >hardware and/or software design for ARM-specific stuff.
> >
> >PCI is more generic though, so we may have to put up with this to some
> >extent.  Can you point me to the affected probing code?  I'm not very
> >familiar with that stuff...
> 
> The marvell pcie always had the option of delivering any bus
> errors as imprecise aborts. However it was /annoying/ and therefore

You don't say ;)

> easier just to turn it off and rely on the hardware returning 0xffff
> for any configuration area it couldn't get to.

Does PCI have any way of finding out which parts of the configuration
space are there before you are forced to go poking around in invalid
address space?

I'm guessing there may not be, otherwise this convsersation might not
be happening ... but I don't know too much about PCI.


Maybe some driver-specific probing hook would make sense, so that we
only need to use the russian roulette approach on hardware that forces
us to.

Cheers
---Dave

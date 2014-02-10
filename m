Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaBJPZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:25:07 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59934 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751791AbaBJPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:25:04 -0500
Date: Mon, 10 Feb 2014 15:24:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Fabrice Gasnier <fabrice.gasnier@st.com>, jonathan.austin@arm.com,
        nico@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org, vgupta@synopsys.com,
        ben.dooks@codethink.co.uk, u.kleine-koenig@pengutronix.de,
        sboyd@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        maxime.coquelin@st.com
Subject: Re: [RFC PATCH] ARM: Add imprecise abort enable/disable macro
Message-ID: <20140210152452.GA26684@n2100.arm.linux.org.uk>
References: <1391789955-26927-1-git-send-email-fabrice.gasnier@st.com> <1391789955-26927-2-git-send-email-fabrice.gasnier@st.com> <20140210141634.GA2794@e103592.cambridge.arm.com> <52F8E5E2.30805@st.com> <20140210151247.GD2794@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210151247.GD2794@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:12:47PM +0000, Dave Martin wrote:
> Firstly, blindly adding 4 to PC is obviouly not right, partly because we
> might be running an unrelated thread by the time the abort fires, and
> also because the affected instruction might not be 4 bytes in size in a
> Thumb kernel.

Exactly.  We ended up on some platforms having special accessors for PCI
where we included a number of 'mov r0, r0' instructions after the accessor
so we could properly cope with them - but this required knowledge that
we were going to only receive an imprecise abort from these accessors
and only for a few cycles after the instruction.

However, that's not true with modern architectures.  The point they're
received will _not_ be the load/store which resulted in the abort, and
in the case of a write, they could be many hundreds of cycles later,
especially if the write has been buffered.

So adding four to the PC is definitely a very /bad/ thing to do.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

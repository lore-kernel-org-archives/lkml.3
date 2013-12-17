Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3LQNFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:05:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55268 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3LQNFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:05:50 -0500
Date: Tue, 17 Dec 2013 13:04:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Xiubo Li <Li.Xiubo@freescale.com>, mark.rutland@arm.com,
        s.hauer@pengutronix.de, galak@codeaurora.org, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, matt.porter@linaro.org,
        rob@landley.net, ian.campbell@citrix.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv7 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131217130435.GV4360@n2100.arm.linux.org.uk>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com> <5295539.cCkPY1PpyC@flatron> <20131217124505.GB17210@ulmo.nvidia.com> <1500339.E8bGm7xZUi@flatron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500339.E8bGm7xZUi@flatron>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 01:54:35PM +0100, Tomasz Figa wrote:
> On Tuesday 17 of December 2013 13:45:06 Thierry Reding wrote:
> > I fail to see how that would eliminate the problem with the types. That
> > said I don't actually see sparse complaining about any type mismatches.
> > That's probably because the various macros implicitly cast to u32.
> 
> Well, in BE variant you would read the register using __raw_readl() into
> a __be32 and then get an u32 from be32_to_cpu() and return it. Similarly
> for writes

__raw_readl() returns a u32, so you'll get a warning trying to assign a
u32 to a __be32.

We do have ioread32() and ioread32be() which do the appropriate conversion,
as well as the write versions too.  They both include the barrier if you're
overly concerned about that.

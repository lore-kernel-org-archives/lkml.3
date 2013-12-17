Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3LQMAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:00:21 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:45592 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3LQMAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:00:19 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Date: Tue, 17 Dec 2013 13:00:10 +0100
Message-ID: <5295539.cCkPY1PpyC@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20131217115136.GT4360@n2100.arm.linux.org.uk>
References: <1386925027-16288-1-git-send-email-Li.Xiubo@freescale.com> <20131217111020.GF13823@ulmo.nvidia.com> <20131217115136.GT4360@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 of December 2013 11:51:36 Russell King - ARM Linux wrote:
> On Tue, Dec 17, 2013 at 12:10:22PM +0100, Thierry Reding wrote:
> > On Fri, Dec 13, 2013 at 04:57:04PM +0800, Xiubo Li wrote:
> > > +static inline u32 fsl_pwm_readl(struct fsl_pwm_chip *fpc,
> > > +		const void __iomem *addr)
> > > +{
> > > +	u32 val;
> > > +
> > > +	val = __raw_readl(addr);
> > > +
> > > +	if (likely(fpc->big_endian))
> > 
> > The likely() probably isn't very useful in this case. But if you want to
> > keep it, it should at least be reversed, since little-endian is actually
> > the default (you have to specify the big-endian property to activate the
> > big endian mode).
> > 
> > > +		val = be32_to_cpu(val);
> > > +	else
> > > +		val = le32_to_cpu(val);
> 
> This will also cause sparse errors, because when sparse is enabled, these
> expect __le32 or __be32 arguments, not u32.

My question is why can't you just create two sets of accessors, one big
endian and one little endian, add two function pointers to your
fsl_pwm_chip struct and let the driver set the to correct accessors in
probe?

This would eliminate the problem with types Russell mentioned and IMHO
make the code cleaner.

Best regards,
Tomasz

> 
> > > +	rmb();
> > 
> > I'd prefer the rmb() to follow the __raw_readl() immediately to make the
> > relationship more explicit.
> 
> A better question to ask is: why is this barrier here?  What memory
> ordering operations is it trying to serialise?

I'd also add a question why __raw accessors are used here.

Best regards,
Tomasz


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaD0Wj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:39:26 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54951 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaD0WjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:39:24 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Date: Mon, 28 Apr 2014 00:39:19 +0200
Message-ID: <4500103.Z38Pp35WUa@typ>
User-Agent: KMail/4.11.5 (Linux/3.11.0-19-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2533407.kJCGHuX10p@diego>
References: <1840959.yqLj3D6H4q@typ> <2533407.kJCGHuX10p@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:lySr3h/1dYcTKens+w1kc2od9HoonY6JSDCmvffgDe2
 1ld7u7tL94gIBhah9/EUJ8IC8SpkiFPexnuE5ubpmmD7Ww1cRp
 628CmwZpXRf/H68jiI6OSPgVEVOW0UUl/+Ui3jYcOpl6YqDiae
 7FmJn02fGXBsNoPtqtMjLCAxxu1YRvAD7t7IXCL29NOXJU3xn5
 AVkLFf0J8v/IhqnoQkhCsJ2/gTRnLzfsFs/6Tl87OSTCXOYF9n
 GW0W45i0EDyvscMcSD8aacFDERi6aMX03qc2C/L89gzlF8dA0T
 Ot2E7sPzvVf5LxEEwqnAFtsP2t81+88979mdS8kc0DhmRcZJQ=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Heiko,

thanks for your comments.

> both the grf as well as the bus-idx are rockchip specific, so they should be
> prefixed (rockchip,grf, etc) and from my personal taste I would hope we
> could invest in an "n" and "e", to make it a full bus-index ;-)
I will change the names to rockchip,grf and rockchip,bus-index.

> the convention seems to be "clock-frequency" for the desired bus speed
> (checked i2c-sirf, i2c-exynos, i2c-at91and i2c-qup).
Thanks for looking that up, will change.

> > + * Driver for I2C unit in Rockchip RK3188 SoC
> 
> RK3188 -> RK3xxx?
yes, of course.

> > +static inline void i2c_writel(struct rk3x_i2c *i2c, u32 value,
> > +			      unsigned int offset)
> > +{
> > +	writel(value, i2c->regs + offset);
> > +}
> > +
> > +static inline u32 i2c_readl(struct rk3x_i2c *i2c, unsigned int offset)
> > +{
> > +	return readl(i2c->regs + offset);
> > +}
> 
> I'm not sure what the policy here is, but is this indirection really
> necessary when it's only doing a normal readl/writel?
I saw that pattern in several device drivers (a quick grep for
"static inline void .*_writel" turns up quite a bit of those). Obviously, it 
doesn't hurt performance-wise as they are just inline functions. I personally 
think that

i2c_writel(i2c, val, REG_CON);

is a bit more concise than

writel(val, i2c->regs + REG_CON);

And it makes tracing easier by giving me a single function were I can trace 
all register accesses, if needed.

But as you said, there might be some policy I don't know about. If you feel 
strongly about it or someone else also votes for plain readl/writel, I will 
happily change it.

Thanks,
  Max

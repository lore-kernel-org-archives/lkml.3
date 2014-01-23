Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbaAWRli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:41:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56608 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035AbaAWRlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:41:35 -0500
Date: Thu, 23 Jan 2014 17:41:21 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vzapolskiy@gmail.com" <vzapolskiy@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
Message-ID: <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
 <52E0EEB8.4080602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E0EEB8.4080602@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:28:08AM +0000, Sylwester Nawrocki wrote:
> Hi,
> 
> (Adding missing devicetre ML list at CC.)
> 
> On 15/01/14 10:14, Naveen Krishna Chatradhi wrote:
> > This patch adds device tree support to the s5p-sss.c crypto driver.
> > 
> > Also, Documentation under devicetree/bindings added.
> > 
> > Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: David S. Miller <davem@davemloft.net>
> > CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> > TO: <linux-crypto@vger.kernel.org>
> > CC: <linux-samsung-soc@vger.kernel.org>
> > ---
> > Changes since v3:
> > None
> > 
> >  .../devicetree/bindings/crypto/samsung-sss.txt     |   20 ++++++++++++++++++++
> >  drivers/crypto/s5p-sss.c                           |   10 +++++++++-
> >  2 files changed, 29 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> > new file mode 100644
> > index 0000000..2f9d7e4
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> > @@ -0,0 +1,20 @@
> > +Samsung SoC SSS (Security SubSystem) module
> > +
> > +The SSS module in S5PV210 SoC supports the following:
> > +-- Feeder (FeedCtrl)
> > +-- Advanced Encryption Standard (AES)
> > +-- Data Encryption Standard (DES)/3DES
> > +-- Public Key Accelerator (PKA)
> > +-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
> > +-- PRNG: Pseudo Random Number Generator
> > +
> > +Required properties:
> > +
> > +- compatible : Should contain entries for this and backward compatible
> > +  SSS versions:
> > +  - "samsung,s5pv210-secss" for S5PV210 SoC.
> > +- reg : Offset and length of the register set for the module
> > +- interrupts : the interrupt-specifier for the SSS module.
> > +		Two interrupts "feed control and hash" in case of S5PV210
> 
> It should be described in what order both interrupts are supposed to be
> specified.
> 
> > +- clocks : the required gating clock for the SSS module.
> > +- clock-names : the gating clock name to be requested in the SSS driver.

The _exact_ names expected must be described in the binding, or this
property is useless.

> > diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> > index 93cddeb..2da5617 100644
> > --- a/drivers/crypto/s5p-sss.c
> > +++ b/drivers/crypto/s5p-sss.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/scatterlist.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/io.h>
> > +#include <linux/of.h>
> >  #include <linux/crypto.h>
> >  #include <linux/interrupt.h>
> >  
> > @@ -177,6 +178,12 @@ struct s5p_aes_dev {
> >  
> >  static struct s5p_aes_dev *s5p_dev;
> >  
> > +static const struct of_device_id s5p_sss_dt_match[] = {
> > +	{ .compatible = "samsung,s5pv210-secss", },
> 
> nit: the first semicolon could be omitted.

I assume you mean comma ratehr than semicolon?

Cheers,
Mark.

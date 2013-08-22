Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3HVNiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:38:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41370 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab3HVNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:38:17 -0400
Date: Thu, 22 Aug 2013 14:37:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130822133730.GB23152@e106331-lin.cambridge.arm.com>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
 <20130820093034.GL31036@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820093034.GL31036@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:30:34AM +0100, Sascha Hauer wrote:
> On Tue, Aug 20, 2013 at 11:11:19AM +0200, Linus Walleij wrote:
> > On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> > > @@ -572,6 +572,8 @@
> > >                         v-i2c-supply = <&db8500_vape_reg>;
> > >
> > >                         clock-frequency = <400000>;
> > > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> > > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> 
> Why do most clocks in this series have the instance number in the clock
> names? This looks very wrong to me.

+1. The clock names should be the input names to the unit, they
shouldn't vary per instance.

Mark.

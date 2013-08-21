Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3HUI2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:28:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54399 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3HUI2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:28:21 -0400
Date: Wed, 21 Aug 2013 09:28:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130821082811.GC29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Linus Walleij wrote:

> On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> > @@ -572,6 +572,8 @@
> >                         v-i2c-supply = <&db8500_vape_reg>;
> >
> >                         clock-frequency = <400000>;
> > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> 
> To avoid confusing the clock name "nmk-i2c.0" with the device
> name in Linux of that device instance, can we use a name such
> that it is clear that this is not a dev_name match?
> 
> "i2c0" works just fine as name I think?

If you do that, then I think you need to change all of these too:

git grep -e "\.0" -e "\.1" -e "\.2" -e "\.3" -- drivers/clk/ux500/

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

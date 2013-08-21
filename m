Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3HUWo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:44:58 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55927 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3HUWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130821082811.GC29850@lee--X1>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-10-git-send-email-lee.jones@linaro.org>
	<CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
	<20130821082811.GC29850@lee--X1>
Date: Thu, 22 Aug 2013 00:44:55 +0200
Message-ID: <CACRpkdYa8QTxY7u_5-wXzQq2yu8sgKKH5dOP=iYHsrrz8g2HOg@mail.gmail.com>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:28 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 20 Aug 2013, Linus Walleij wrote:
>> On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
>> > @@ -572,6 +572,8 @@
>> >                         v-i2c-supply = <&db8500_vape_reg>;
>> >
>> >                         clock-frequency = <400000>;
>> > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
>> > +                       clock-names = "nmk-i2c.0", "apb_pclk";
>>
>> To avoid confusing the clock name "nmk-i2c.0" with the device
>> name in Linux of that device instance, can we use a name such
>> that it is clear that this is not a dev_name match?
>>
>> "i2c0" works just fine as name I think?
>
> If you do that, then I think you need to change all of these too:
>
> git grep -e "\.0" -e "\.1" -e "\.2" -e "\.3" -- drivers/clk/ux500/

No, as I said in some other patch, all these clk_register_clkdev()s
are unused in device tree boots and should not even be executed
on the DT boot path.

(But maybe you've proven me wrong there in this other
thread ...)

Yours,
Linus Walleij

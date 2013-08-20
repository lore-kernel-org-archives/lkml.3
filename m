Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab3HTJLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:11:21 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56418 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3HTJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-10-git-send-email-lee.jones@linaro.org>
Date: Tue, 20 Aug 2013 11:11:19 +0200
Message-ID: <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
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

On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:

> +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> @@ -572,6 +572,8 @@
>                         v-i2c-supply = <&db8500_vape_reg>;
>
>                         clock-frequency = <400000>;
> +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> +                       clock-names = "nmk-i2c.0", "apb_pclk";

To avoid confusing the clock name "nmk-i2c.0" with the device
name in Linux of that device instance, can we use a name such
that it is clear that this is not a dev_name match?

"i2c0" works just fine as name I think?

Linus

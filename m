Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3HWNDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 09:03:52 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43873 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab3HWNDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 09:03:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZJ_2HF_r8cKpMrG1Usy5bD8Fr7GM_k2Btzxgk71G-VvA@mail.gmail.com>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
	<1377260620-18829-33-git-send-email-lee.jones@linaro.org>
	<CACRpkdZJ_2HF_r8cKpMrG1Usy5bD8Fr7GM_k2Btzxgk71G-VvA@mail.gmail.com>
Date: Fri, 23 Aug 2013 15:03:50 +0200
Message-ID: <CACRpkdZGD3O-iYiT7sNbyx8imKGOF+uk864BA97FhzJ5EksD+g@mail.gmail.com>
Subject: Re: [PATCH 32/40] ARM: ux500: Delete U8500 UIB support when booting
 with ATAGs
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 2:53 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

> It is not true at all that all HREFs have the STUIB mounted.

Hm I'm confused here...

arch/arm/boot/dts/[ste-]stuib.dtsi does define this stuff
so forget about the misplaced comments.

For *all* HREF boards. As it is included from both
[ste-]hrefprev60.dts and [ste-]hrefv60plus.dts

However it is only really mounted on some of the HREFs,
and the following stays valid:

> This detection needs to stay for now, unless we go and define
> in the device tree which UIB is mounted, which would be unfortunate
> as we can very well auto-detect it, and that makes it easier for
> a user to just swap the UIB and test the other toch screen
> (for example).

So it would be really nice to keep this autodetection.

What would be nice if we could mark all the STUIB as
"disabled" in the device trees, and then augment the device tree
at boot depending on if we find something at 0x44 as in this
test:

> -       /* U8500-UIB has the TC35893 at 0x44 on I2C0, the ST-UIB doesn't. */
> -       ret = i2c_smbus_xfer(i2c0, 0x44, 0, I2C_SMBUS_WRITE, 0,
> -                       I2C_SMBUS_QUICK, NULL);

And then mark these as "okay" in the DT.

That's pretty high-tech but I bet we can pull it off (and set
a good example).

Yours,
Linus Walleij

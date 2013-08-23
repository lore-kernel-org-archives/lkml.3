Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3HWMxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:53:37 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62533 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3HWMxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1377260620-18829-33-git-send-email-lee.jones@linaro.org>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
	<1377260620-18829-33-git-send-email-lee.jones@linaro.org>
Date: Fri, 23 Aug 2013 14:53:35 +0200
Message-ID: <CACRpkdZJ_2HF_r8cKpMrG1Usy5bD8Fr7GM_k2Btzxgk71G-VvA@mail.gmail.com>
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

On Fri, Aug 23, 2013 at 2:23 PM, Lee Jones <lee.jones@linaro.org> wrote:

> It's time to remove all ATAG support from ux500 and rely solely on
> Device Tree booting. This patch is part of that endeavour.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

This needs some more afterthought.

> -       i2c0 = i2c_get_adapter(0);
> -       if (!i2c0) {
> -               __mop500_uib_init(&mop500_uibs[STUIB],
> -                               "fallback, could not get i2c0");
> -               return -ENODEV;
> -       }
> -
> -       /* U8500-UIB has the TC35893 at 0x44 on I2C0, the ST-UIB doesn't. */
> -       ret = i2c_smbus_xfer(i2c0, 0x44, 0, I2C_SMBUS_WRITE, 0,
> -                       I2C_SMBUS_QUICK, NULL);
> -       i2c_put_adapter(i2c0);
> -
> -       if (ret == 0)
> -               uib = &mop500_uibs[U8500UIB];
> -       else
> -               uib = &mop500_uibs[STUIB];
> -
> -       __mop500_uib_init(uib, "detected");
> +       __mop500_uib_init(&mop500_uibs[STUIB], "detected");

It is not true at all that all HREFs have the STUIB mounted.

This detection needs to stay for now, unless we go and define
in the device tree which UIB is mounted, which would be unfortunate
as we can very well auto-detect it, and that makes it easier for
a user to just swap the UIB and test the other toch screen
(for example).

Yours,
Linus Walleij

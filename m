Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab3BXAQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 19:16:25 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61051 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab3BXAQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 19:16:22 -0500
MIME-Version: 1.0
In-Reply-To: <201302231857.46445.heiko@sntech.de>
References: <201302231855.47560.heiko@sntech.de>
	<201302231857.46445.heiko@sntech.de>
Date: Sun, 24 Feb 2013 01:16:21 +0100
Message-ID: <CACRpkdbV-CznfnbCbKkKpndjiG32V9yNdrF1F7M=4qe1EUroGA@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 6:57 PM, Heiko Stübner <heiko@sntech.de> wrote:

> When pinctrl is not built the fallback functions fail silently
> and emit either 0 error codes or NULL pinctrl handles.
>
> Therefore it's needed to also check for this NULL-handle when
> falling back to parsing the i2c gpios from devicetree.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

NAK.

This is not the right solution for this driver.

It uses pinctrl in a very simplistic way, just grabbing the
default handler.

After commit
ab78029ecc347debbd737f06688d788bd9d60c1d:
"drivers/pinctrl: grab default handles from device core"

The right solution is to simply revert commit
2693ac69880a33d4d9df6f128415b65e745f00ba
"i2c: s3c2410: Add support for pinctrl"

Tomasz are you OK with this, or will you add more
fine-grained pinctrl (like runtime PM etc) to this driver?

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab3IQMUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:20:17 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:40918 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3IQMUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <1378742636-11215-2-git-send-email-g.liakhovetski@gmx.de>
References: <1378742636-11215-1-git-send-email-g.liakhovetski@gmx.de>
	<1378742636-11215-2-git-send-email-g.liakhovetski@gmx.de>
Date: Tue, 17 Sep 2013 14:20:14 +0200
Message-ID: <CACRpkdbDa5Smpfyneq-SAPYvbxB-ju7-X8kkZ7RFpNcYrcBggg@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: sh-pfc: r8a7790: add pin definitions for the
 I2C3 interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 6:03 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:

> There are four I2C interfaces on r8a7790, each of them can be connected to
> one of the two respective I2C controllers, e.g. interface #0 can be
> configured to work with I2C0 or with IIC0. Additionally some of those
> interfaces can also use one of several pin sets. Interface #3 is special,
> because it can be used in automatic mode for DVFS. It only has one set
> of pins available and those pins cannot be used for anything else, they
> also lack the GPIO function.
>
> This patch uses the sh-pfc ability to configure pins, not associated with
> GPIOs and adds support for I2C3 to the r8a7790 PFC set up.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Pls CC Laurent who is main reviewer on all sh-pfc stuff.

> +/* R8A7790 has 6 banks with 32 GPIOs in each = 192 GPIOs */
> +#define ROW_GROUP_A(r) ('Z' - 'A' + 1 + (r))
> +#define PIN_NUMBER(r, c) (((r) - 'A') * 16 + (c) + 200)
> +#define PIN_A_NUMBER(r, c) PIN_NUMBER(ROW_GROUP_A(r), c)

You add these #defines but do not use them.

Yours,
Linus Walleij

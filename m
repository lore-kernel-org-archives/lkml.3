Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaIWJsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 05:48:10 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:41586 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaIWJsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 05:48:06 -0400
MIME-Version: 1.0
In-Reply-To: <4cf96e22ce2c7646513b64260c7bb1a2279e232d.1410020459.git.stefan@agner.ch>
References: <cover.1410020458.git.stefan@agner.ch>
	<4cf96e22ce2c7646513b64260c7bb1a2279e232d.1410020459.git.stefan@agner.ch>
Date: Tue, 23 Sep 2014 11:48:05 +0200
Message-ID: <CACRpkdYk0zW12qNXgOstTLmdVDYacu0Un+8quTN+J_azOic7AA@mail.gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: imx: add gpio pinmux support for vf610
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 6:25 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
> This is needed since direction configuration is not part of the
> GPIO module in Vybrid.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
(...)

> -arch_initcall(vf610_pinctrl_init);
> +postcore_initcall(vf610_pinctrl_init);

Why is this necessary? You should be able to rely on deferred
probing to do its work here. I think this should be module_init()
or driver_initcall() really.

Yours,
Linus Walleij

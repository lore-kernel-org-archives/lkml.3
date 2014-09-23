Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaIWOLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:11:21 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61740 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIWOLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:11:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Joe. C" <srv_yingjoe.chen@mediatek.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        "Hongzhou. Yang" <srv_hongzhou.yang@mediatek.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        srv_heupstream@mediatek.com,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, dandan.he@mediatek.com
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
Date: Tue, 23 Sep 2014 16:10:09 +0200
Message-ID: <7840459.vtELiqVIOL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411480694.21299.18.camel@mtksdaap41>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com> <2770365.r419rjIAOU@wuerfel> <1411480694.21299.18.camel@mtksdaap41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ljzHxTKvVMHx6TC6lMSG8vL3knsSD93lo4KVoAqXxux
 j3wcolafbenEoReGs7mx2ekgZuiONb6W7r7rHLc8SLQGF2aDNQ
 pYqIx9R/MSJ0faOJf56Bz9CwjtuqK03mEdZrsToNWjG5k/4o4n
 ZDujhFEsT/Eh0tWssMc3YkV3AkRqq8/oZobspAkw0sY2Dq99zA
 vV3jAILHelRqwaNDvDoAXIhzrxUqRpLIzInDK5mllJnVRjWpqm
 fHQE7PRKt74ExQZ9XbPFQMAg9+CW4C//Qg6+WGk1D3phkM8QH8
 M0UHNj8agcot7NniIuZOtvBoz6PrntuusglwWcDWaBnCElNXo7
 AfmsjHzc/XTuMx+mdtUs=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 21:58:14 Joe. C wrote:
> Thanks for review. 
> The intend for these macros is helpin pinctrl user to write DT node.
> With these macro, we could write like this for i2c0:
> 
> mediatek,pinfunc = <MT8135_PIN_100_SDA0__FUNC_SDA0 
>                         MT8135_PIN_101_SCL0__FUNC_SCL0>;
> 
> We feel this is less error prone and easier to write than this:
> 
> mediatek,pinfunc = <MT_PIN_FUNC(100, 1) MT_PIN_FUNC(101, 1)>

But you don't actually use the same macros in the driver, so in effect
you just move the definitions from the file they are needed in to another
file as a macro.

It is no less error prone to define those macros in mt8135-pinfunc.h
than in the pinctrl node, just less readable.

	Arnd

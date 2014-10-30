Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132AbaJ3KKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:51 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55006 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbaJ3KKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: flora.fu@mediatek.com
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, arm@kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/3] dt-bindings: Add Reset Controller for MediaTek SoC
Date: Thu, 30 Oct 2014 11:10:20 +0100
Message-ID: <2323181.epJX0Uxj7x@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414638733-10080-3-git-send-email-flora.fu@mediatek.com>
References: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com> <1414638733-10080-3-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oYRLtE0pAEe/6LC+UAKNAwB2EMWQOuwO4PuW6dU/x0+
 1P6rmZ/w4TUI9JQMntrgAQFmqF7+zM9fpB6hmw7aHyVGXYK6OA
 vx2JRbKCwdYcRqkn/sKQh38W1n1JdqcM5eBVsoEQo7EDl44pxM
 bbvCO9kuTHnHabgQdITJLO85bxfUMRFZd3La90pM9G79PdE/U8
 b2mKfqoB6TPHtFY+8y9Z5QYIO3X+2JZN/l7zNq61uninYFw1GT
 psonw8Ha6IpEMYibtVSZEJ07wJaQXr0JWVmBkLxf84u8MOS+2E
 F474P9Z2TViHtIvrG4IXozQ8cUeR7z3W2a21KtpwfWm3MSTsvC
 dW+UVChNuciRLcGTe1sA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 11:12:12 flora.fu@mediatek.com wrote:
> +
> +example:
> +       infrarst: reset-controller@10001030 {
> +               #reset-cells = <1>;
> +               compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
> +               mediatek,syscon-reset = <&infracfg 0x30 0x8>;
> +       };

I think you need to change the 'unit-address' now, i.e. the @10001030
value above no longer matches any reg property. You could just
remove that part.

> +Specifying reset lines connected to IP modules
> +==============================================
> +
> +The reset controller(mtk-reset) manages various reset sources. Those device nodes should
> +specify the reset line on the rstc in their resets property, containing a phandle to the
> +rstc device node and a RESET_INDEX specifying which module to reset, as described in 
> +reset.txt.
> +
> +For MediaTek SoC, RESET_INDEX is reset bit defined in INFRACFG or PERICFG registers.
> +
> +example:
> +pwrap: pwrap@1000f000 {
> +       compatible = "mediatek,mt8135-pwrap";
> +       reg = <0 0x1000f000 0 0x1000>,
> +               <0 0x11017000 0 0x1000>;
> +       reg-names = "pwrap-base",
> +               "pwrap-bridge-base";
> +       resets = <&infrarst 7>, <&perirst 34>;
> +       reset-names = "infrarst", "perirst";
> +       };
> +};
> 

You have an extraneous '};' here.

	Arnd

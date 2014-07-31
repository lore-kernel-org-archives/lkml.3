Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaGaLqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:46:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20356 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaGaLqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:46:01 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c9-53da2c7592ba
Message-id: <53DA2C74.3010101@samsung.com>
Date: Thu, 31 Jul 2014 13:45:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
 <1406805732-17372-5-git-send-email-hsnaves@gmail.com>
In-reply-to: <1406805732-17372-5-git-send-email-hsnaves@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xK7qlOreCDdYdMLJo3lRsMf/IOVaL
	/5+esVmce7WS0aJ3wVU2i02Pr7FaXN41h81ixvl9TBbrZ7xmsdg8YSObA5fHzll32T1WLv/C
	5rF5Sb1H35ZVjB6bT1d7fN4kF8AWxWWTkpqTWZZapG+XwJWxdONN5oLpPBVn9i9mbmC8ydnF
	yMEhIWAi8XxxRBcjJ5ApJnHh3nq2LkYuDiGBpYwSFybeYYFwPjFKdK5fxwhSxSugJXHo8wEw
	m0VAVWJ1705WEJtNwFCi92gfWFxUIELiQN8zVoh6QYkfk++xgCwTEdCROLwqF2Qms8ApJokZ
	ZzvA6oUFvCTeb+xjArGFBColPkztYAexOQWcJHYtngY2hxmod3/rNDYIW15i85q3zBMYBWYh
	WTELSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoTEwZcdjIuPWR1iFOBgVOLh
	jbh5JViINbGsuDL3EKMEB7OSCG+n2q1gId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxNhR/PLX92
	kJWh8t0u97s79FT0G39HzgnPXHvsXWTtzHex7BdLFfW5pzgeeLB/6+JXjT43xRV1Suvl/3S+
	WvN8ZqLfTMmTB2QZdy3YJ7hoUneNz9Zvtlbs81ItzMJ/fv4W8D/i9OMzf7nqBW7kTjD8V79q
	uXPM0eUdDeuW8h9a8fvC7ieevUy/lViKMxINtZiLihMBzVia22ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(dropping linux-doc ML and Randy from Cc)

On 31/07/14 13:22, Humberto Silva Naves wrote:
> This implements the fixed rate clocks generated either inside or
> outside the SoC. It also adds a dt-binding constant for the
> sclk_hdmiphy clock, which shall be later used by other drivers,
> such as the DRM.
> 
> Since the external fixed rate clock fin_pll is now registered by
> the clk-exynos5410 file, the bindings with the device tree file have
> changed. It is no longer needed to define fin_pll as a fixed clock,
> such as in:
> 
> 	fin_pll: xxti {
>   		compatible = "fixed-clock";
> 	  	clock-frequency = <24000000>;
> 	  	clock-output-names = "fin_pll";
> 	  	#clock-cells = <0>;
> 	};
> 
> The above lines should be replaced by the following lines:
> 
> 	fixed-rate-clocks {
> 		oscclk {
> 			compatible = "samsung,exynos5410-oscclk";
> 			clock-frequency = <24000000>;
> 		};
> 	};
> 
> This new form of binding was properly documented in the relevant
> documentation file.

Can you explain what is rationale behind this change ? Is it related to
suspend/resume ordering ?
Obviously it breaks the kernel/dtb compatibility. We should be moving
in opposite direction, i.e. completely remove the custom samsung fixed
rate clocks. I've tried to address this with patches [1], [2] but Tomasz
wasn't happy with them IIRC and I postponed work on that.

[1] http://www.spinics.net/lists/arm-kernel/msg333211.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/258490.html

--
Regards,
Sylwester

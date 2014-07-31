Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaGaMxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 08:53:19 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54569 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaGaMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 08:53:17 -0400
Message-ID: <53DA3C36.1040206@gmail.com>
Date: Thu, 31 Jul 2014 14:53:10 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-5-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406805732-17372-5-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

You can find my comments inline.

On 31.07.2014 13:22, Humberto Silva Naves wrote:
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

In general this is backwards. This Exynos-specific clock binding was
invented before generic fixed rate clock binding showed up and so few
drivers still use it to maintain DT ABI compatibility. However new
drivers are required to use the new generic binding and so does the one
for Exynos5410.

Best regards,
Tomasz

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab3LICM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:12:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab3LICM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:12:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/6] ARM: at91/dt: define sama5d3 clocks
Date: Mon, 9 Dec 2013 03:09:23 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1385650171-8756-1-git-send-email-b.brezillon@overkiz.com> <1385650228-8906-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1385650228-8906-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090309.23723.arnd@arndb.de>
X-Provags-ID: V02:K0:FGk9M65Kaqak+niXD2gIP+hlB6Gu7U18u2UKkZfj3F1
 K3xGTrqIrEOIuCX88L6yxmQuBSXpxQcz/63Ax6EnvlsORct5pS
 m/fklefLldG3NQV48rM/NApEM2kj2TbzbsJsA0AO2m2QsK0mQY
 zWkl2c24lXGqHkMKMHn6cDseB9OpPQgnmxf3YiQPCSLrc6b64f
 lTL7R0GKsq7SXArDsWDGEuw8cBktRhto/NVqLZJfTSEmkg/hHE
 vt4IV65rEdD80l63z8YY7rA4qVAQgqgKdBJeicIl0D1RYfd1M7
 UCK4eqH3+qM39AtuAudBvv95MPsFziYsQIngArliOWuhW/WMtV
 H8NCAgLwyzbAMD1I7f+E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 November 2013, Boris BREZILLON wrote:
> @@ -92,6 +103,8 @@
>  				dma-names = "tx", "rx";
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_spi0>;
> +				clocks = <&spi0_clk>;
> +				clock-names = "spi_clk";
>  				status = "disabled";
>  			};
>  
> @@ -101,6 +114,8 @@
>  				interrupts = <38 IRQ_TYPE_LEVEL_HIGH 4>;
>  				pinctrl-names = "default";
>  				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +				clocks = <&ssc0_clk>;
> +				clock-names = "pclk";
>  				status = "disabled";
>  			};
>  

You are adding "clock-names" properties in a lot of cases. Are you sure you
are using the strings that are documented in the respective device bindings
for each name? In a lot of cases, drivers just want an anonymous clock
and we don't name them.

	Arnd

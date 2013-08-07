Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3HGQJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:09:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33504 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756330Ab3HGQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:09:06 -0400
Date: Wed, 7 Aug 2013 18:08:54 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Mark Brown <broonie@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: at91/dt: split sam9x5 peripheral definitions
Message-ID: <20130807180854.41b4bedb@skate>
In-Reply-To: <1375870466-1093-1-git-send-email-b.brezillon@overkiz.com>
References: <1375870466-1093-1-git-send-email-b.brezillon@overkiz.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Boris BREZILLON,

On Wed,  7 Aug 2013 12:14:26 +0200, Boris BREZILLON wrote:
> This patch splits the sam9x5 peripheral definitions into:
> - a common base for all sam9x5 SoCs (at91sam9x5.dtsi)
> - several optional peripheral definitions which will be included by specific
>   sam9x5 SoCs (at91sam9x5_'periph name'.dtsi)
> 
> This provides a better representation of the real hardware (drop unneeded
> dt nodes) and avoids future peripheral id conflict (lcdc and isi both use
> peripheral id 25).
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  arch/arm/boot/dts/at91sam9g25.dtsi       |    2 +
>  arch/arm/boot/dts/at91sam9g35.dtsi       |    1 +
>  arch/arm/boot/dts/at91sam9x25.dtsi       |   24 ++---------
>  arch/arm/boot/dts/at91sam9x35.dtsi       |    1 +
>  arch/arm/boot/dts/at91sam9x5.dtsi        |   67 ------------------------------
>  arch/arm/boot/dts/at91sam9x5_macb0.dtsi  |   56 +++++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9x5_macb1.dtsi  |   44 ++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9x5_usart3.dtsi |   51 +++++++++++++++++++++++
>  8 files changed, 158 insertions(+), 88 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_macb0.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_macb1.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9x5_usart3.dtsi

Hum, do we really want to have .dtsi files per peripheral? I might have
overlooked this, but I think it's the first time we would have this in
arch/arm/boot/dts.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

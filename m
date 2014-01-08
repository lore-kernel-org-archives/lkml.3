Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaAHKlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:41:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaAHKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:41:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Roger Quadros <rogerq@ti.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, tony@atomide.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        "Kristo, Tero" <t-kristo@ti.com>, bcousson@baylibre.com,
        linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 1/5] mfd: omap-usb-host: Update DT clock binding information
Date: Wed, 08 Jan 2014 11:40:14 +0100
Message-ID: <4840680.vVGZYBJBID@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52CD2807.9000200@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com> <4812867.NuB3hNkV9d@wuerfel> <52CD2807.9000200@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y36a8yKh9ciBG+ZX6pI1MzPi5wJKo8csDJapl4q01BF
 h1QL9IrMYktMSnTPKEASNn917E4K/qsyZgN0bIJ1FKr1vkLQtl
 t0WIblAOVHYVL4ihMOXicUXjNCKfLXIKwIEt3Lbt5ssof4cV9Y
 I/k/cduidfoNcsS+1oCHmMgAgeBTMo+jmyZytkZqM9VtqHzpf3
 JQC9wdksjHaCQU7ZIDf/4EWC58rwfUC0xlRA3C8whLBteTrMgP
 oYCyBkN2NAKluyRjsM8H/hc4EFElASPstDLriv8xpOUx63W4YC
 YzbzkSeCmDyyaF7Nc+hr5byy9bQGFFRCwF3ImmGDzaOfWlSOsR
 bmMUFmD6kUqr+SmfGbJs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014 15:57:19 Roger Quadros wrote:
> It is a clock gate defined like so in the DT clock data
> 
> on OMAP4
>         init_60m_fclk: init_60m_fclk {
>                 #clock-cells = <0>;
>                 compatible = "ti,divider-clock";
>                 clocks = <&dpll_usb_m2_ck>;
>                 reg = <0x0104>;
>                 ti,dividers = <1>, <8>;
>         };
> 
> on OMAP5
>         l3init_60m_fclk: l3init_60m_fclk {
>                 #clock-cells = <0>;
>                 compatible = "ti,divider-clock";
>                 clocks = <&dpll_usb_m2_ck>;
>                 reg = <0x0104>;
>                 ti,dividers = <1>, <8>;
>         };
> 
> So you can see that it is the same thing with a different name.

Right, but init_60m_fclk is the name of the clock output of the
divider here, which is /not/ what you should put in the "clock-names"
property of the consumer. The clock input name should reflect what
the clock is used for instead.

	Arnd

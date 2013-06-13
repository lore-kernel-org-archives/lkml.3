Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370Ab3FMWHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:07:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56729 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab3FMWHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:07:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: cfa10036: Add USB0 OTG port
Date: Fri, 14 Jun 2013 00:06:51 +0200
Message-ID: <24013808.T2v7Fa5NMK@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371131025-12200-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com> <1371131025-12200-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qXigVANsgcc8y5yaDKt5LMnSPtuBVZOiKCvIrNQ1hhT
 kkAaQNBmNazR610OsvLtpPH1ZxSrj3z9vKV5IO3jKEm3s4hOdE
 SiUcrdQTYToT9XzvhHkCoGvXo5FcsaGylJDHypD358K2vUzy4c
 kOCZDUlNyaFzDddEzI065tr4V9mW+429KXTvhoFlMD5hZaWWEV
 S0N8exrK+a96w2Gbvjb+Ao7mTcELXVAy0xDmndAHQf8u2o8dOe
 8NEQbP0cbyf2hewU144yB/amXg74rlAQOagSLCAUbnZE/24psO
 cbG2ykDwfN2V/xeHqBatXRs7czHKD/ILyBo2smySyxaoVXt/gW
 cSZ4GeKUHiwpapkBY4q0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 June 2013 15:43:42 Maxime Ripard wrote:
> +
> +       ahb@80080000 {
> +               usb0: usb@80080000 {
> +                       pinctrl-names = "default";
> +                       pinctrl-0 = <&usb0_otg_cfa10036>;
> +                       status = "okay";
>                 };
>         };
> 

The patches all look good, just one trivial comment about the fragment above:

There is already a "usb0" label in the imx28.dtsi file for the same
node. When you refer to the node from a board.dts file, either leave
out the redundant label, or use it to simplify the statements above
to the brief version:

	&usb0 {
		pinctrl-names = "default";
		pinctrl-0 = <&usb0_otg_cfa10036>;
		status = "okay";
	};


	Arnd

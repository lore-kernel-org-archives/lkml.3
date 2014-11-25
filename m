Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaKYM6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:58:44 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:62915 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaKYM6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:58:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk,
        jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com,
        gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net,
        broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com,
        florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sprdlinux@freelists.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v3 4/5] arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and defconfig
Date: Tue, 25 Nov 2014 13:57:31 +0100
Message-ID: <3490516.nCDXzA8J8x@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nXk0MyW55G3PkdXLYbkNGcf5IzT4MuXJMDpuLpqze26
 fBOjkFERDcn1K8sa00NFQgsioQ07u3/EFm8gC7V4AEWFH3S8YX
 k3xGVeKiLtTNeF5WiUwCJ9hMidnWhX48iF8L/QRw4sBy/3GMns
 n+RLj7jqtldn1XTIHrhLEEZJcrrH6A/QhZ/3Kes1LhcroPLpzH
 1xNtAIw58B78fol5Tw+SaG79rhklMZUfmZzheiBycJSG21yx8B
 wyHicVlpvTGZpKEGD0j3df+16buDVu7ZrBUdTiDDiLEhwGCWZM
 Mnmt/OPav6dDx0E9bu6DUTdgsvm6YhtRJASZpWmDohRr1SnTWM
 RArbvI8iVOQMNCOhyejE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2014 20:16:57 Chunyan Zhang wrote:
> 
> +menuconfig ARCH_SPRD
> +       bool "Spreadtrum SoC platform"
> +       depends on ARM64
> +       help
> +         Support for Spreadtrum ARM based SoCs
> +
> +if ARCH_SPRD
> +
> +config ARCH_SHARKL64
> +       bool "Sharkl64 SoC Platform"
> +       help
> +         Sharkl64 is a Spreadtrum's SoC Platform which is based
> +         on ARM 64-bit processor core including
> +           sc9836
> +
> +endif #ARCH_SPRD
> +

I don't think we need multiple levels here, it should be enough to
have either ARCH_SPRD or ARCH_SHARKL64, because all device drivers
are going to be optional anyway. Typically a Kconfig symbol covers
all SoCs that are related, so if you Spreadtrum are doing both
phone and server chips and these are designed independently, you
would have two symbols, but if you only expect to see phone chips
here that are all derived from the same product line, using ARCH_SPRD
to refer to all of them should be enough.

	Arnd

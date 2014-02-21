Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbaBUP7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:59:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbaBUP7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:59:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, kishon@ti.com,
        linux-samsung-soc@vger.kernel.org, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] phy: Select PHY_EXYNOS_DP_VIDEO by default for ARCH_EXYNOS
Date: Fri, 21 Feb 2014 16:59 +0100
Message-ID: <1753680.KKj0Q1erxA@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1392997802-29050-2-git-send-email-s.nawrocki@samsung.com>
References: <1392997802-29050-1-git-send-email-s.nawrocki@samsung.com> <1392997802-29050-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aZ+aK4M3nR7HYXa+fXSQNBwRJomRT+G/QKHgD45h605
 NrAQkawSzPKs4vBeGlhfmIXKFDKwSA5Fj9LoqdV64GULfNLO3l
 oJqAEsYUnzBMYfvtdFi743CxuoMS9V7LnchPv6xuucrOFkLpkM
 uISF8j3KYRS2qiXzajm0iACmMcBAo1QAdxWC7MhgjnVrB9NN19
 SUShpbHKplcqsx8wI7/t0YMMCCtFjJGjZOxgLWUkTsUfHD/EXh
 DX2YLrUH1Fb9NiK+jfVkzvLAIDq+80e/kRk+otNDcBcfXfZhpD
 JQRzbGWvsThMclFVO206tb4ajVGTYtIzc8aOP0K9X1AIh3Cbmi
 3gJNwseXOqjYvKwPbkjE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 February 2014 16:50:02 Sylwester Nawrocki wrote:
>  config PHY_EXYNOS_DP_VIDEO
>         tristate "EXYNOS SoC series Display Port PHY driver"
>         depends on OF
> +       depends on ARCH_EXYNOS || COMPILE_TEST
> +       default y
>         select GENERIC_PHY
>         help
> 

That would turn them on automatically if you enable COMPILE_TEST, which
is probably not what you want.

How about "default ARCH_EXYNOS"?

	Arnd

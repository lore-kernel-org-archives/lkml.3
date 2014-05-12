Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbaELJbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:31:42 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61200 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaELJbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:31:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/4] arm: add basic support for Mediatek MT6589 boards
Date: Mon, 12 May 2014 11:30:15 +0200
Message-ID: <80525303.7Oax6ZBozr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399772463-859-4-git-send-email-matthias.bgg@gmail.com>
References: <1399772463-859-1-git-send-email-matthias.bgg@gmail.com> <1399772463-859-4-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Sm3BuK8Le03+0cal+B1rqb4jcbNY7m58bocYK7Rq5O4
 8tdddXtqJGFLja7cYW1vKUV427JOpvIW+V1s+EsWQX6LpIoSFT
 YOv34+9PAhAiK61X/2zvnIO8idQ0oe7eMeGVqJ9MXl3m4tRp3g
 WcMHuUiW9dkeZh7F7DxXwqj+BJ57k553StFZpkEEEZBePKbLdb
 UGRrBB67JoMs9YHLuEdSnP4cUJJyz3VppmimLOvwYUiB6MsI2G
 iaxu/TyI9Zpqrv2RL3zCIYW8gpsvnMZiUuiJ57FzZ/kxZfWjiA
 klHuPBstB8zBMcBC14CkK5aHQuvibu6YRQnUxtgILTkyBr2YdO
 2a31O63wDO8Jx8EjXDe0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2014 03:41:02 Matthias Brugger wrote:
> +
> +static void __init mediatek_dt_init(void)
> +{
> +       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +}
> +
> +static const char * const mediatek_board_dt_compat[] = {
> +       "mediatek,mt6589",
> +       NULL,
> +};
> +
> +DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
> +       .init_machine   = mediatek_dt_init,
> +       .dt_compat      = mediatek_board_dt_compat,
> +MACHINE_END

Since the mediatek_dt_init function now only does the default populate
call, you can leave it out completely and keep only the compat list.

	Arnd

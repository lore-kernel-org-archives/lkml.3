Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbaDWQDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:03:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:56643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbaDWQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:03:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH 5/5] ARM: sunxi: Remove sun4i and sun7i machine definitions
Date: Wed, 23 Apr 2014 18:02:51 +0200
Message-ID: <1401022774.yKcHJAmPtb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398265476-29373-6-git-send-email-maxime.ripard@free-electrons.com>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com> <1398265476-29373-6-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:a6wBz9KrHQy8X7KkkyppnhMRoLXQMX9Tfc2WAuC1Ycw
 75Ct0SNjAlu51+dMsVLOGF4T/ZWsozqvzn3fHdCSxPJylcMzdw
 4kV2mkSigtARs4NahqeFxkf4X0aNxnz9TYMqkikUwAVYik01bl
 An9OY74I4sVHcw29KwowyIqBD0wLS/eOoGgZyfN6SQYy/4BKo9
 nr5uMOjfBboXXs3ZnyfxusYZ4BKQ79YjdBVfR/kE88RGqVDce7
 gW7jVbRKuKJQooxd3Z+4sfHjIXM8VlsBRTnzAIT0coDLSQmhpx
 FbmcgLZLguBR9N3DuagdPQejwsweHawIuOcGbIVqEcRUhlQ8aD
 iodsO0jW3pcCOBZ65jTQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014 17:04:36 Maxime Ripard wrote:
>  
> -static void __init sunxi_dt_init(void)
> -{
> -       of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> -}
> -
> -static const char * const sunxi_board_dt_compat[] = {
> -       "allwinner,sun4i-a10",
> -       "allwinner,sun5i-a10s",
> -       "allwinner,sun5i-a13",
> -       NULL,
> -};
> -
> -DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
> -       .init_machine   = sunxi_dt_init,
> -       .dt_compat      = sunxi_board_dt_compat,
> -MACHINE_END
> -
>  static const char * const sun6i_board_dt_compat[] = {
>         "allwinner,sun6i-a31",
>         NULL,

I'd like to hear more opinions on this. We could either rely
on the generic code, or we could keep the entry with just
the .dt_compat line and the name, so /proc/cpuinfo contains
a meaningful platform name.

Either approach works for me, but I think we should do this
consistent across platforms. Olof, do you have an opinion?

	Arnd

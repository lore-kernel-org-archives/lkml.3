Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaLIJAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:00:15 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:62697 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaLIJAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:00:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Olof Johansson <olof@lixom.net>, mturquette@linaro.org,
        f.fainelli@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: bcm: kona: don't return -EFOO as bool
Date: Tue, 09 Dec 2014 09:59:42 +0100
Message-ID: <13166134.ThBvWAfRgN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418075645-14571-1-git-send-email-olof@lixom.net>
References: <1418075645-14571-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:WKmaoo8dHJBsVo8MBJbh+7BLMTe+EviChc80m+J/JhcAeDSlzOe
 H8h0H/O5ICbnQyoPSXoH7dWj1z8UP/6nD4ctaWrqjABcl3xyqBEpj1TrrjMXqXzhwLCb+tm
 X+VTx1eTItC1GaBoLr3PVSWAChLnDaOCbtLHzgiHUtgvCCqQCVFyQnwG+QEbaYkKjQDLL7d
 Pkla5QSaAPczqVZxxscDA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2014 13:54:04 Olof Johansson wrote:
> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> index 95af2e6..53fca77 100644
> --- a/drivers/clk/bcm/clk-kona.c
> +++ b/drivers/clk/bcm/clk-kona.c
> @@ -1252,7 +1252,7 @@ static bool __kona_clk_init(struct kona_clk *bcm_clk)
>         default:
>                 BUG();
>         }
> -       return -EINVAL;
> +       return false;
>  }

Nothing wrong with your patch, but the __kona_clk_init() function is
still very strange. Note that the return statement is unreachable,
and the reason for the BUG() statement to not be hit is that all
kona clocks have type=bcm_clk_peri.

	Arnd

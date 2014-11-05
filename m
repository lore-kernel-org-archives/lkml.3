Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaKEAst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:48:49 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:51644 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKEAsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:48:47 -0500
MIME-Version: 1.0
In-Reply-To: <1415146961-25993-1-git-send-email-kristina.martsenko@gmail.com>
References: <1747777414.897866.1414878004147.JavaMail.open-xchange@oxbsltgw09.schlund.de>
	<1415146961-25993-1-git-send-email-kristina.martsenko@gmail.com>
Date: Tue, 4 Nov 2014 22:48:45 -0200
Message-ID: <CAOMZO5CKB4aHTyYCvnT0UZCi4Pe+XyDa2-G1kpzyce1J3y3nfQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: fix card detection regression
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Michael Heimpold <mhei@heimpold.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristina,

On Tue, Nov 4, 2014 at 10:22 PM, Kristina Martšenko
<kristina.martsenko@gmail.com> wrote:
> Since commit 89168b489915 ("mmc: core: restore detect line inversion
> semantics"), the SD card on i.MX28 (and possibly other) devices isn't
> detected and booting stops at:
>
> [    4.120617] Waiting for root device /dev/mmcblk0p3...
>
> This is caused by the MMC_CAP2_CD_ACTIVE_HIGH flag being set incorrectly
> when the host controller doesn't use a GPIO for card detection (but
> instead uses a dedicated pin). In this case mmc_gpiod_request_cd() will
> return before assigning to the gpio_invert variable, leaving the
> variable uninitialized. The variable then gets used to set the flag.
> This patch fixes the issue by making sure gpio_invert is set to false
> when a GPIO isn't used. After this patch, i.MX28 boots fine.
>
> The MMC_CAP2_RO_ACTIVE_HIGH (write protect) flag is also set incorrectly
> for the exact same reason (it uses the same uninitialized variable), so
> this patch fixes that too.
>
> Fixes: 89168b489915 ("mmc: core: restore detect line inversion semantics")
> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Kristina Martšenko <kristina.martsenko@gmail.com>

This fixes mx28 card detection, thanks!

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

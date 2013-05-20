Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab3ETLrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:47:16 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:44926 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315Ab3ETLrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 07:47:14 -0400
MIME-Version: 1.0
In-Reply-To: <1368765198-25550-1-git-send-email-dianders@chromium.org>
References: <1368746388-20194-1-git-send-email-dianders@chromium.org>
	<1368765198-25550-1-git-send-email-dianders@chromium.org>
Date: Mon, 20 May 2013 13:47:14 +0200
Message-ID: <CACRpkdZ1zBrp+jpgw8o_PVd_bcQMpkFXvRAwfJH6KCztT4jx+w@mail.gmail.com>
Subject: Re: [PATCH v3] pinctrl: samsung: fix suspend/resume functionality
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 6:33 AM, Doug Anderson <dianders@chromium.org> wrote:

> The GPIO states need to be restored after s2r and this is not currently
> supported in the pinctrl driver. This patch saves the gpio states before
> suspend and restores them after resume.
>
> Saving and restoring is done very early using syscore_ops and must
> happen before pins are released from their powerdown state.
>
> Patch originally from Prathyush K <prathyush.k@samsung.com> but
> rewritten by Doug Anderson <dianders@chromium.org>.
>
> Signed-off-by: Prathyush K <prathyush.k@samsung.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes in v3:
> - Skip save and restore for banks with no powerdown config.
>
> Changes in v2:
> - Now uses sycore_ops to make sure we're early enough.
> - Try to handle two CON registers better.
> - Should handle s3c24xx better as per Heiko.
> - Simpler code; no longer tries to avoid glitching lines since
>   we _think_ all current SoCs should have pins in power down state
>   when the restore is called.
> - Dropped eint patch for now; Tomasz will post his version.

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

How are you going to merge this?

Samsung tree?

My pinctrl development tree?

Or my fixes tree, if it's a regression for v3.10?

Yours,
Linus Walleij

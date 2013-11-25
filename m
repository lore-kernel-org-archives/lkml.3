Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3KYXls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:41:48 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:51705 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3KYXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:41:44 -0500
MIME-Version: 1.0
In-Reply-To: <1384841915-8264-1-git-send-email-ch.naveen@samsung.com>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
	<1384841915-8264-1-git-send-email-ch.naveen@samsung.com>
Date: Mon, 25 Nov 2013 15:41:43 -0800
X-Google-Sender-Auth: Gc0ePVQ7rXW99iPKoWRNTicJwPY
Message-ID: <CAD=FV=Wu13jiFggjp9FZrnB0ejODR7ix_jSby+waZwpcACLwXA@mail.gmail.com>
Subject: Re: [PATCH v3] i2c: s3c2410: dont need CPU_FREQ transitions for
 exynos series
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "broonie@kernel.org" <broonie@kernel.org>, "cpgs ." <cpgs@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Mon, Nov 18, 2013 at 10:18 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> For Exynos4 and Exynos5 SoCs from Samsung the i2c clock is based
> on a fixed 66 MHz peripheral clock, and therefore is completely
> independent of the cpu frequency.
> Thus, registering for a CPU freq notifier is very wasteful.
>
> This patch modifes the code such that, i2c bus registers to
> cpu_freq_transition only if CONFIG_CPU_FREQ_S3C24XX is enabled.
>
> This change should save a bunch of cpufreq transitions calls
> which does not apply to exynos SoCs.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
> Changes since v2:
> None, Rebased on for-next of linux-i2c git repo.
>
> Changes since v1:
> Use CONFIG_CPU_FREQ_S3C24XX instead of (CONFIG_CPU_FREQ & !CONFIG_EXYNOS)
> As commented by Tomasz
>
>  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Can you please spin this with comments from
<https://patchwork.kernel.org/patch/3235091/>?  Thanks!

-Doug

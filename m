Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaLOXm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 18:42:26 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56434 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaLOXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 18:42:24 -0500
MIME-Version: 1.0
In-Reply-To: <1418685929-13096-1-git-send-email-dianders@chromium.org>
References: <1418685929-13096-1-git-send-email-dianders@chromium.org>
Date: Mon, 15 Dec 2014 15:42:23 -0800
X-Google-Sender-Auth: Y6-lYy2v9miELwd3-L71JcgfgNg
Message-ID: <CAL1qeaEGYwTCf0xasMZhGHEDWYhddLAS9jYjdgrccSwnFOc+7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mmc: core: Add mmc_regulator_set_vqmmc()
From: Andrew Bresticker <abrestic@chromium.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, Mark Brown <broonie@kernel.org>,
        Alexandru Stan <amstan@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>, johan.rudholm@axis.com,
        tim.kryger@gmail.com, andrew_gabbasov@mentor.com,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Mon, Dec 15, 2014 at 3:25 PM, Doug Anderson <dianders@chromium.org> wrote:
> This adds logic to the MMC core to set VQMMC.  This is expected to be
> called by MMC drivers like dw_mmc as part of (or instead of) their
> start_signal_voltage_switch() callback.
>
> A few notes:
>
> * When setting the signal voltage to 3.3V we do our best to make VQMMC
>   and VMMC match.  It's been reported that this makes some old cards
>   happy since they were tested back in the day before UHS when VQMMC
>   and VMMC were provided by the same regulator.  A nice side effect of
>   this is that we don't end up on the hairy edge of VQMMC (2.7V),
>   which some EEs claim is a little too close to the minimum for
>   comfort.
>
> * When setting the signal voltage to 1.8V or 1.2V we aim for that
>   specific voltage instead of picking the lowest one in the range.
>
> * We very purposely don't print errors in mmc_regulator_set_vqmmc().
>   There are cases where the MMC core will try several different
>   voltages and we don't want to pollute the logs.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Looks good to me.

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>

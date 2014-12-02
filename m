Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbaLBRym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 12:54:42 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:48925 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaLBRyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 12:54:40 -0500
MIME-Version: 1.0
In-Reply-To: <1417531977-30094-1-git-send-email-jay.xu@rock-chips.com>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
	<1417531977-30094-1-git-send-email-jay.xu@rock-chips.com>
Date: Tue, 2 Dec 2014 09:54:39 -0800
X-Google-Sender-Auth: 3MXdnuPiN1uDMSv5zR3-PdZz7sQ
Message-ID: <CAD=FV=Uwb1NxxCoXHzHu6DJCpnG_HV2RhCr3JaJaXbJja8kd7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output
 clock to codec
From: Doug Anderson <dianders@chromium.org>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>, perex@perex.cz,
        tiwai@suse.de, Sonny Rao <sonnyrao@chromium.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jianqun,

This ought to be a "v3" patch and ideally ought to describe
differences from v2 (after the cut).  Please have Kever or Chris
review your next patch before sending it out since I think they are
familiar with the process.


On Tue, Dec 2, 2014 at 6:52 AM, Jianqun Xu <jay.xu@rock-chips.com> wrote:
> From: Sonny Rao <sonnyrao@chromium.org>
>
> We need to claim the clock which is driving the codec so that when we enable
> clock gating, we continue to clock the codec when needed.  I make this an
> optional clock since there might be some applications where we don't need it
> but can still use the I2S block.
>
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

You still forgot your own signed-off-by.  Please try again.  See
<https://patchwork.kernel.org/patch/5334991/>


> +       i2s->oclk = devm_clk_get(&pdev->dev, "i2s_clk_out");
> +       if (IS_ERR(i2s->oclk)) {
> +               dev_dbg(&pdev->dev, "Didn't find output clock\n");
> +               i2s->oclk = NULL;
> +       }

You still forgot the blank line here requested by Heiko.  Please try
again.  See <https://patchwork.kernel.org/patch/5334991/>


> +       if (i2s->oclk)
> +               ret = clk_prepare_enable(i2s->oclk);
> +

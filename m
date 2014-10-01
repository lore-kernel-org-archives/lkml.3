Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaJAWrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:47:11 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:56657 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaJAWrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <1412185241-24950-1-git-send-email-amstan@chromium.org>
References: <1412185241-24950-1-git-send-email-amstan@chromium.org>
Date: Wed, 1 Oct 2014 15:47:06 -0700
X-Google-Sender-Auth: gboDIbfzrLKDqpnlRuqTDfuHdkI
Message-ID: <CAD=FV=VV1U2o41iz_NANvk=EZcMcrurvhN31s--_srU=4yuWcA@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: fix 0 length write transfers
From: Doug Anderson <dianders@chromium.org>
To: Alexandru M Stan <amstan@chromium.org>
Cc: Max Schwarz <max.schwarz@online.de>, Wolfram Sang <wsa@the-dreams.de>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        ZhengShunQian <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

On Wed, Oct 1, 2014 at 10:40 AM, Alexandru M Stan <amstan@chromium.org> wrote:
> i2cdetect -q was broken (everything was a false positive, and no transfers were
> actually being sent over i2c). The way it works is by sending a 0 length write
> request and checking for NACK. This patch fixes the 0 length writes and actually
> sends them.
>
> Reported-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Alexandru M Stan <amstan@chromium.org>
> ---
>  drivers/i2c/busses/i2c-rk3x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> index b41d979..f486d0e 100644
> --- a/drivers/i2c/busses/i2c-rk3x.c
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -238,7 +238,7 @@ static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
>         for (i = 0; i < 8; ++i) {
>                 val = 0;
>                 for (j = 0; j < 4; ++j) {
> -                       if (i2c->processed == i2c->msg->len)
> +                       if ((i2c->processed == i2c->msg->len) && (cnt != 0))

This looks good to me.  Basically we still need to write the address
of the device onto the bus even if there's no data.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>

-Doug

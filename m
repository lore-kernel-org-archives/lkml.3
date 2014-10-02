Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaJBNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:31:37 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50104 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaJBNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:31:35 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Alexandru M Stan <amstan@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Doug Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        ZhengShunQian <zhengsq@rock-chips.com>,
        linux-rockchip@lists.infradead.org, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: rk3x: fix 0 length write transfers
Date: Thu, 02 Oct 2014 15:30:47 +0200
Message-ID: <2239755.0FknEeHYOT@typ>
User-Agent: KMail/4.13.3 (Linux/3.15.7-031507-generic; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1412185241-24950-1-git-send-email-amstan@chromium.org>
References: <1412185241-24950-1-git-send-email-amstan@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:k4cviFsUKBCgzTTCeNL6DCIT2imNxUCl3B3EQTyJDfj
 4+ZzN2n6a5Ou/yWQeqpEneTXcGTxkYS6Ajs19R/n6NkLJ+Qf6m
 CZoAwH0DisswgexORT+74i0l0K3qlKbkayl2ETFrgtQpqhPk3j
 VrwxIDLl4YeDB8WhgVnj0tkikmsfNH14IW4LW5Bbhgqk92R2Ax
 aGpDEkoLjvepcX+KRoDVtmt9tPvFMvHpcrtau6N9Wrc7fcq1do
 yci1oFUXeYCLgYvDj+i3b0/wRdpRmaork5fpUzcOnOL1+hbplZ
 2yhm8H2BkLc1e6UustwNf8CiNml1zM+eKJR4kdijNFiLLpVGw=
 =
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandru,

On Wednesday 01 October 2014 at 10:40:41, Alexandru M Stan wrote:
> i2cdetect -q was broken (everything was a false positive, and no transfers
> were actually being sent over i2c). The way it works is by sending a 0
> length write request and checking for NACK. This patch fixes the 0 length
> writes and actually sends them.
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
> @@ -238,7 +238,7 @@ static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c
> *i2c) for (i = 0; i < 8; ++i) {
>  		val = 0;
>  		for (j = 0; j < 4; ++j) {
> -			if (i2c->processed == i2c->msg->len)
> +			if ((i2c->processed == i2c->msg->len) && (cnt != 0))
>  				break;
> 
>  			if (i2c->processed == 0 && cnt == 0)

Yes, looks correct and makes i2cdetect work for me on Radxa Rock.

Reviewed-By: Max Schwarz <max.schwarz@online.de>
Tested-By: Max Schwarz <max.schwarz@online.de>

Cheers,
  Max

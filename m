Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaIMUyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:54:13 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:46056 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaIMUyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:54:12 -0400
Message-ID: <5414AFA6.9060904@cogentembedded.com>
Date: Sat, 13 Sep 2014 23:57:10 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jianqun <jay.xu@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
CC: huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH 4/5] ASoC: rockchip-i2s: fix registers' property of rockchip
 i2s controller
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com> <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com>
In-Reply-To: <1410568932-21823-1-git-send-email-jay.xu@rock-chips.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/13/2014 3:42 AM, Jianqun wrote:

> Reference rockchip I2S controller TRM, modify some registers' property
> I2S_FIFOLR: read / write, but not volatile, not precious
> I2S_INTSR: read / write
> I2S_CLR: volatile, register value will be cleared by read

> Test on RK3288 with max98090.

> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
>   sound/soc/rockchip/rockchip_i2s.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
> index 1b9b404..6595383 100644
> --- a/sound/soc/rockchip/rockchip_i2s.c
> +++ b/sound/soc/rockchip/rockchip_i2s.c
[...]
> @@ -385,8 +387,6 @@ static bool rockchip_i2s_volatile_reg(struct device *dev, unsigned int reg)
>   static bool rockchip_i2s_precious_reg(struct device *dev, unsigned int reg)
>   {
>   	switch (reg) {
> -	case I2S_FIFOLR:
> -		return true;
>   	default:
>   		return false;
>   	}

    Shouldn't this be folded into simple *return* false now?

WBR, Sergei



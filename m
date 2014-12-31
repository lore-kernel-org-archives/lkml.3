Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaLaQet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 11:34:49 -0500
Received: from smtp-out-118.synserver.de ([212.40.185.118]:1057 "EHLO
	smtp-out-118.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaLaQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 11:34:48 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 501
Message-ID: <54A425A3.2070108@metafoo.de>
Date: Wed, 31 Dec 2014 17:34:43 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Andrew Jackson <andrew.jackson@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ASoC: adi: Add missing return statement.
References: <1420042837-3337-1-git-send-email-andrew.jackson@arm.com>
In-Reply-To: <1420042837-3337-1-git-send-email-andrew.jackson@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2014 05:20 PM, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>
> The probe routine was disabling the clock even
> if the system was configured successfully.  Add
> a return statement to leave clocks enabled.
>
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks, never noticed since the clock is shared with other peripherals.

> ---
> Spotted while reviewing clock preparation
>
>   sound/soc/adi/axi-i2s.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/sound/soc/adi/axi-i2s.c b/sound/soc/adi/axi-i2s.c
> index 7752860..4c23381 100644
> --- a/sound/soc/adi/axi-i2s.c
> +++ b/sound/soc/adi/axi-i2s.c
> @@ -240,6 +240,8 @@ static int axi_i2s_probe(struct platform_device *pdev)
>   	if (ret)
>   		goto err_clk_disable;
>
> +	return 0;
> +
>   err_clk_disable:
>   	clk_disable_unprepare(i2s->clk);
>   	return ret;
>


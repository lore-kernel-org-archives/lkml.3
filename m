Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaJUQOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:14:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49830 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaJUQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:14:21 -0400
Message-ID: <54468671.7060000@wwwdotorg.org>
Date: Tue, 21 Oct 2014 10:14:41 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alban Bedel <alban.bedel@avionic-design.de>, linux-kernel@vger.kernel.org
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] ASoC: tegra: Read and use the GPIO flags of the headphone
 detect
References: <1413905609-23268-1-git-send-email-alban.bedel@avionic-design.de>
In-Reply-To: <1413905609-23268-1-git-send-email-alban.bedel@avionic-design.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 09:33 AM, Alban Bedel wrote:
> The headphone detect was hardcoded to low-active, use the flags from
> DT to allow high-active as well.

> diff --git a/sound/soc/tegra/tegra_rt5640.c b/sound/soc/tegra/tegra_rt5640.c

> @@ -44,6 +44,7 @@
>   struct tegra_rt5640 {
>   	struct tegra_asoc_utils_data util_data;
>   	int gpio_hp_det;
> +	enum of_gpio_flags gpio_hp_det_flags;

I have no idea why that's an enum if it's meant to be interpreted as a 
bit mask, but that's an issue with of_gpio.h, not this patch.

Acked-by: Stephen Warren <swarren@nvidia.com>

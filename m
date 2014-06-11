Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaFLUuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:50:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbaFLUuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:50:39 -0400
Date: Wed, 11 Jun 2014 11:54:25 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, broonie@kernel.org,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ASoC: wm_adsp: Move DVFS control into codec driver
Message-ID: <20140611105425.GA12074@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com> <20140609150314.GC5229@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609150314.GC5229@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 04:03:14PM +0100, Richard Fitzgerald wrote:
>  
> -#define WM_ADSP2(wname, num) \
> +#define WM_ADSP2_E(wname, num, event_fn) \
>  {	.id = snd_soc_dapm_dai_link, .name = wname " Preloader", \
> -	.reg = SND_SOC_NOPM, .shift = num, .event = wm_adsp2_early_event, \
> +	.reg = SND_SOC_NOPM, .shift = num, .event = event_fn, \
>  	.event_flags = SND_SOC_DAPM_PRE_PMU }, \

You need to add a SND_SOC_DAPM_PRE_PMD in here otherwise your
wm5102_sysclk_ev won't get called on power down.

Thanks,
Charles

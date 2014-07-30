Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaG3G3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:29:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:64241 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbaG3G3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:29:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551111189"
Message-ID: <53D890C7.4080201@linux.intel.com>
Date: Wed, 30 Jul 2014 09:29:27 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: jianqun <xjq@rock-chips.com>, broonie@kernel.org, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, tbleung@chromium.org,
        dgreid@chromium.org, kevin.strasser@intel.com, swarren@nvidia.com,
        ralph.birt@maximintegrated.com
CC: heiko@sntech.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: max98090 not need to return fail if fail to request
 hpdet irq.
References: <1406685010-25108-1-git-send-email-xjq@rock-chips.com>
In-Reply-To: <1406685010-25108-1-git-send-email-xjq@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 04:50 AM, jianqun wrote:
> From: xujianqun <xjq@rock-chips.com>
>
> Since hardware may not MUST to use IRQ pin of max98090 as jack detect, the
> driver can work well without it, can report jack trigger to CPU by a GPIO.
>
> But here driver will register fail caused by failed to request irq.
>
> Signed-off-by: xujianqun <xjq@rock-chips.com>
> ---
>   sound/soc/codecs/max98090.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
> index 566919c..bc124ff 100644
> --- a/sound/soc/codecs/max98090.c
> +++ b/sound/soc/codecs/max98090.c
> @@ -2515,6 +2515,8 @@ static int max98090_probe(struct snd_soc_codec *codec)
>   
>   	max98090_add_widgets(codec);
>   
> +	return 0;
> +
>   err_access:
>   	return ret;
>   }
I would say it's better to call request_threaded_irq() conditionally 
when max98090->irq is valid in the same max98090_probe(). Also code 
should return instantly in case of request_threaded_irq() fails for 
valid irq.

Now code is still printing needless error message in case max98090->irq 
is invalid or not specified and continue probing in case 
request_threaded_irq() fails for valid irq.

-- 
Jarkko

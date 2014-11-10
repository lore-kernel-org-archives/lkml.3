Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaKJMyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:54:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44717 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaKJMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:54:08 -0500
Message-ID: <5460B549.40203@ti.com>
Date: Mon, 10 Nov 2014 14:53:29 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anil Kumar <anilk4.v@gmail.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>
CC: <perex@perex.cz>, <tiwai@suse.de>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ASoC: davinvi-mcasp: Balance pm_runtime_enable() on probe
 failure
References: <1415537114-9642-1-git-send-email-anilk4.v@gmail.com>
In-Reply-To: <1415537114-9642-1-git-send-email-anilk4.v@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 02:45 PM, Anil Kumar wrote:
> If probe fails then we need to call pm_runtime_disable() to balance
> out the previous pm_runtime_enable() call.

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
> ---
> :100644 100644 0eed9b1... 99c747d... M	sound/soc/davinci/davinci-mcasp.c
>  sound/soc/davinci/davinci-mcasp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
> index 0eed9b1..99c747d 100644
> --- a/sound/soc/davinci/davinci-mcasp.c
> +++ b/sound/soc/davinci/davinci-mcasp.c
> @@ -1235,6 +1235,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
>  	ret = pm_runtime_get_sync(&pdev->dev);
>  	if (IS_ERR_VALUE(ret)) {
>  		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
> +		pm_runtime_disable(&pdev->dev);
>  		return ret;
>  	}
>  
> 


-- 
Péter

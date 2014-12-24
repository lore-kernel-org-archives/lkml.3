Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaLXG5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:57:02 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:37165 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751563AbaLXG5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:57:00 -0500
Message-ID: <549A6394.10507@arm.com>
Date: Wed, 24 Dec 2014 06:56:20 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] ASoC: dwc: Prepare clock before use
References: <cover.1419342218.git.Andrew.Jackson@arm.com> <63becb5f356c25b226b9dbc5825357e894d0f08b.1419342218.git.Andrew.Jackson@arm.com>
In-Reply-To: <63becb5f356c25b226b9dbc5825357e894d0f08b.1419342218.git.Andrew.Jackson@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/14 13:56, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
> 
> Some I2S clocks may require some time to get the clock ready
> for operation and so need to be prepared before they are enabled.
> So, prepare the clock as well as enabling it, but combine the
> two through clk_prepare_enable.

More turkey-focussed issues: this should have a clk_disable_unprepare too.  Sigh

	Andrew

> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> ---
>  sound/soc/dwc/designware_i2s.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
> index 06d3a34..9573ec7 100644
> --- a/sound/soc/dwc/designware_i2s.c
> +++ b/sound/soc/dwc/designware_i2s.c
> @@ -411,7 +411,7 @@ static int dw_i2s_probe(struct platform_device *pdev)
>  	if (IS_ERR(dev->clk))
>  		return  PTR_ERR(dev->clk);
>  
> -	ret = clk_enable(dev->clk);
> +	ret = clk_prepare_enable(dev->clk);
>  	if (ret < 0)
>  		goto err_clk_put;
>  
> 


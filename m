Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaL3Mjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:39:54 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33443 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaL3Mjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:39:52 -0500
Message-ID: <54A29D14.6000705@cogentembedded.com>
Date: Tue, 30 Dec 2014 15:39:48 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Jackson <andrew.jackson@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
CC: mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        pawel.moll@arm.com, Arnd Bergmann <arnd@arndb.de>,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>, robh+dt@kernel.org,
        galak@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/6] ASoC: dwc: Prepare clock before use
References: <cover.1419936132.git.Andrew.Jackson@arm.com> <faa0193d388fe808c2fae461954bb1730ba29244.1419936132.git.Andrew.Jackson@arm.com>
In-Reply-To: <faa0193d388fe808c2fae461954bb1730ba29244.1419936132.git.Andrew.Jackson@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/30/2014 1:55 PM, Andrew Jackson wrote:

> From: Andrew Jackson <Andrew.Jackson@arm.com>

> Some I2S clocks may require some time to get the clock ready
> for operation and so need to be prepared before they are enabled.
> So, prepare the clock as well as enabling it, but combine the
> two through clk_prepare_enable.

> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> ---
>   sound/soc/dwc/designware_i2s.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)

> diff --git a/sound/soc/dwc/designware_i2s.c b/sound/soc/dwc/designware_i2s.c
> index 5e9d163..08608c1 100644
> --- a/sound/soc/dwc/designware_i2s.c
> +++ b/sound/soc/dwc/designware_i2s.c
[...]
> @@ -426,13 +426,16 @@ static int dw_i2s_probe(struct platform_device *pdev)
[...]
>   static int dw_i2s_remove(struct platform_device *pdev)
>   {
> +	struct dw_i2s_dev *dev = dev_get_drvdata(&pdev->dev);

    Why not just platform_get_drvdata(pdev)?

[...]

WBR, Sergei


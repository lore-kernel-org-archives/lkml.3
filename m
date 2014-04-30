Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaD3Du5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:50:57 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52609 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaD3Duy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:50:54 -0400
Message-ID: <53607317.4040206@linaro.org>
Date: Wed, 30 Apr 2014 09:20:47 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Xia Kaixu <kaixu.xia@linaro.org>, linux-kernel@vger.kernel.org
CC: alsa-devel@alsa-project.org, linaro-kernel@lists.linaro.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-samsung-soc@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/15] ASoC: samsung-idma: avoid 64-bit division
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org> <1398770316-19715-5-git-send-email-kaixu.xia@linaro.org>
In-Reply-To: <1398770316-19715-5-git-send-email-kaixu.xia@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 04:48 PM, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> dma_addr_t may be 64 bit wide, which causes a build failure
> when doing a division on it. Here it is safe to cast to an
> u32 type, which avoids the problem.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Sangbeom Kim <sbkim73@samsung.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-samsung-soc@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> ---

Tested with ARM_LPAE enabled. Without this patch, getting following error.

sound/built-in.o: In function `iis_irq':
sound/soc/samsung/idma.c:277: undefined reference to `__aeabi_uldivmod'

Tested-by: Tushar Behera <tushar.behera@linaro.org>

>  sound/soc/samsung/idma.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
> index 3d5cf15..e9891b4 100644
> --- a/sound/soc/samsung/idma.c
> +++ b/sound/soc/samsung/idma.c
> @@ -274,7 +274,7 @@ static irqreturn_t iis_irq(int irqno, void *dev_id)
>  
>  		addr = readl(idma.regs + I2SLVL0ADDR) - idma.lp_tx_addr;
>  		addr += prtd->periodsz;
> -		addr %= (prtd->end - prtd->start);
> +		addr %= (u32)(prtd->end - prtd->start);
>  		addr += idma.lp_tx_addr;
>  
>  		writel(addr, idma.regs + I2SLVL0ADDR);
> 


-- 
Tushar Behera

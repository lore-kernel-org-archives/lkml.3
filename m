Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbaDHPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:49:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36873 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbaDHPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:49:45 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-21-53441a951e8c
Message-id: <53441A92.7010108@samsung.com>
Date: Tue, 08 Apr 2014 17:49:38 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com,
        a.hajda@samsung.com, kishon@ti.com
Subject: Re: [PATCH 3/4] clk: exynos4: enable clk_set_parent() propagation for
 sclk_hdmi and sclk_mixer clocks
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
 <1396623201-26000-4-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1396623201-26000-4-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e/4Vd2pUi7BBpPfmlncWneO1aL33Ekm
	i/lHgKwrX9+zWUy6P4HFonfBVTaLC0972CzONr1ht9j0+BqrxeVdc9gsZpzfx2TxdMJFNovD
	Kw4wWcyY/JLNYt7nnUwW89pfsjoIeCz4fIXdY+esu+wed67tYfPY/u0Bq8f97uNMHpuX1Hv0
	bVnF6HH8xnYmj8+b5AI4o7hsUlJzMstSi/TtErgyfnz5zVowi6+iu6GPpYHxFncXIyeHhICJ
	xPJnk9khbDGJC/fWs3UxcnEICSxllFgy6RQjhPOZUeL+lWagDAcHr4CWRPNcdRCTRUBV4umh
	IJBeNgE1ic8Nj9hAbH6gijVN11lAbFGBCIl7jYdZQWxeAUGJH5PvsYCMFBG4wyixtPET2DJm
	gTeMEm9mf2QGqRIWKJC4eH4tWIeQQDujxKp7XiA2p4CnxOzzm8GmMgtYS6yctI0RwpaX2Lzm
	LfMERsFZSJbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh8fd1B+PSY1aH
	GAU4GJV4eCuPOAULsSaWFVfmHmKU4GBWEuH9y+cSLMSbklhZlVqUH19UmpNafIiRiYNTqoGx
	hmcl015B3++ed9fNiZjz8V262MooeaOaOJ4LkqKbpzB4PI43XLrMYataofPaFLFXq79rs244
	VnNd7vbnrjPG7LKmfSd+yoZovF5x/vuS+vZnF14Zfnxprh6WYSxUvdniSkrX97TDhbL/nlQc
	trSQbhFaLfN2UkeX2opzk2Y95H6bd+RsDvN6JZbijERDLeai4kQAz1G6U50CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.04.2014 16:53, Tomasz Stanislawski wrote:
> This patch enables clk_set_parent() propagation for clocks used
> by s5p-tv and exynos-drm drivers.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos4.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index 528f8eb..87b8264 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -680,7 +680,8 @@ static struct samsung_gate_clock exynos4_gate_clks[] __initdata = {
>   	 * the device name and clock alias names specified below for some
>   	 * of the clocks can be removed.
>   	 */
> -	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0, 0, 0),
> +	GATE(CLK_SCLK_HDMI, "sclk_hdmi", "mout_hdmi", SRC_MASK_TV, 0,
> +		CLK_SET_PARENT_PARENT, 0),
>   	GATE(CLK_SCLK_SPDIF, "sclk_spdif", "mout_spdif", SRC_MASK_PERIL1, 8, 0,
>   		0),
>   	GATE(CLK_JPEG, "jpeg", "aclk160", GATE_IP_CAM, 6, 0, 0),
> @@ -880,7 +881,8 @@ static struct samsung_gate_clock exynos4210_gate_clks[] __initdata = {
>   			E4210_SRC_MASK_LCD1, 12, CLK_SET_RATE_PARENT, 0),
>   	GATE(CLK_SCLK_SATA, "sclk_sata", "div_sata",
>   			SRC_MASK_FSYS, 24, CLK_SET_RATE_PARENT, 0),
> -	GATE(CLK_SCLK_MIXER, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4, 0, 0),
> +	GATE(CLK_SCLK_MIXER, "sclk_mixer", "mout_mixer", SRC_MASK_TV, 4,
> +			CLK_SET_PARENT_PARENT, 0),
>   	GATE(CLK_SCLK_DAC, "sclk_dac", "mout_dac", SRC_MASK_TV, 8, 0, 0),
>   	GATE(CLK_TSADC, "tsadc", "aclk100", GATE_IP_PERIL, 15,
>   			0, 0),
>

Looks fine, but since it depends on patch 1/4, which needs to be 
discussed a bit, I'll hold on with applying it for now.

Best regards,
Tomasz

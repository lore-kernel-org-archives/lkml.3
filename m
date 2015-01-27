Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbbA0RJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:09:59 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54892 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367AbbA0RJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:09:54 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-5c-54c7c5cffb96
Message-id: <54C7C653.6080904@samsung.com>
Date: Tue, 27 Jan 2015 18:09:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v4 1/3] ASoC: samsung: Add machine driver for
 Trats2
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
 <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
In-reply-to: <1421989410-12490-2-git-send-email-ideal.song@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t/xy7rnjx4PMfj9gtXiysVDTBZTHz5h
	s5h/5ByrRf+bhawWB/7sYLTY9fc+o8W5VysZLfofv2a2+Halg8li0+NrrBaXd81hs5hxfh+T
	xe3LvBZLr19kspgwfS2LReeuflaL1r1H2C0urvjCZPFy8xsmB2GPDZ+b2DzWzFvD6NHS3MPm
	cbmvl8lj56y77B4rl39h89i0qpPN4861PWwem5fUe+x7u4zNo2/LKkaPzaerPT5vkgvgjeKy
	SUnNySxLLdK3S+DKaD7ziqXgFk/Fq/lpDYzbuboYOTkkBEwkFlw8wwRhi0lcuLeerYuRi0NI
	YCmjxKVN39khnE+MErtuH2MDqeIV0JJ4+ucmUAcHB4uAqkTHG2uQMJuAoUTv0T5GEFtUIELi
	5N097BDlghI/Jt9jAbFFBNQkZtzpZQKZySxwkFniUctBsAZhgXCJnf/WMkIsa2aUODR3F1gH
	p4C7xJ+7N5hBljEL6Encv6gFEmYWkJfYvOYt8wRGgVlIdsxCqJqFpGoBI/MqRtHU0uSC4qT0
	XEO94sTc4tK8dL3k/NxNjJAo/bKDcfExq0OMAhyMSjy8HEXHQ4RYE8uKK3MPMUpwMCuJ8LYc
	AQrxpiRWVqUW5ccXleakFh9iZOLglGpgnHxzdZny9OsdRoEzV/2vuOm4r3G+wpamzMPLPG/K
	THq69Glgqt3jQAa2vJou0e/8WoEW25mKSyvfXpDoVbZzMpqzWFNtclnI112pM/aHX1O49fFV
	eP9HXi3Nljd3/WwdnkttP3418veEbWs/9/ydlWk/y0jLx1D/41pzlQ/bdO9HneWaIbNpnxJL
	cUaioRZzUXEiAEDsqZKwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 06:03, Inha Song wrote:
> +static int trats2_aif1_startup(struct snd_pcm_substream *substream)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
> +	int ret;
> +
> +	ret = clk_prepare_enable(priv->clk_mclk);
> +	if (ret) {
> +		dev_err(rtd->card->dev, "Failed to enable mclk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void trats2_aif1_shutdown(struct snd_pcm_substream *substream)
> +{
> +	struct snd_soc_pcm_runtime *rtd = substream->private_data;
> +	struct trats2_machine_priv *priv = snd_soc_card_get_drvdata(rtd->card);
> +
> +	clk_disable_unprepare(priv->clk_mclk);
> +}
> +
> +static const struct snd_soc_ops trats2_aif1_ops = {
> +	.startup = trats2_aif1_startup,
> +	.shutdown = trats2_aif1_shutdown,
> +	.hw_params = trats2_aif1_hw_params,
> +};

> +static int trats2_audio_probe(struct platform_device *pdev)
> +{

> +	priv->clk_mclk =  of_clk_get_by_name(codec_node, "MCLK1");
> +	if (IS_ERR(priv->clk_mclk)) {
> +		dev_err(&pdev->dev, "Failed to get mclk clock\n");
> +		of_node_put(codec_node);
> +		return PTR_ERR(priv->clk_mclk);
> +	}

Wouldn't it also work if we added clock handling into the wm8994 codec
driver instead? Not sure if it is correct to retrieve the codec's clock
in the machine driver like this. Or perhaps the MCLK1 (SoC CLKOUT) clock
should be added to the sound DT node and handled only by the machine
driver, together with the other (MCLK2) clock?

> +	of_node_put(codec_node);

--
Regards,
Sylwester

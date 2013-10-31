Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3JaHyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:54:18 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51392 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3JaHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:54:16 -0400
Message-ID: <52720CA4.3090003@gmail.com>
Date: Thu, 31 Oct 2013 08:54:12 +0100
From: =?ISO-8859-1?Q?Philippe_R=E9tornaz?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Nicolin Chen <b42378@freescale.com>
CC: s.hauer@pengutronix.de, timur@tabi.org, shawn.guo@linaro.org,
        broonie@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, pawel.moll@arm.com,
        linux-doc@vger.kernel.org, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        galak@codeaurora.org, dmaengine@vger.kernel.org,
        ijc+devicetree@hellion.org.uk, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/4] ASoC: fsl_ssi: Add dual fifo mode support
References: <cover.1383197521.git.b42378@freescale.com> <0e947536358af7bd6e179559006a3526801a1abe.1383197521.git.b42378@freescale.com>
In-Reply-To: <0e947536358af7bd6e179559006a3526801a1abe.1383197521.git.b42378@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>
> +			/* When using dual fifo mode, we need to keep watermark
> +			 * as even numbers due to dma script limitation.
> +			 */
> +			ssi_private->dma_params_tx.maxburst /= 2;
> +			ssi_private->dma_params_tx.maxburst *= 2;
> +			ssi_private->dma_params_rx.maxburst /= 2;
> +			ssi_private->dma_params_rx.maxburst *= 2;
>

Why not using a mask here ?
ssi_private->dma_params_tx.maxburst &= ~0x1;
ssi_private->dma_params_rx.maxburst &= ~0x1;

Regards,

Philippe


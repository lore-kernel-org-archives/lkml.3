Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3JaMEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:04:35 -0400
Received: from muin.pair.com ([209.68.1.55]:58114 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab3JaMEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:04:33 -0400
Message-ID: <5272474D.5000207@tabi.org>
Date: Thu, 31 Oct 2013 07:04:29 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Nicolin Chen <b42378@freescale.com>, s.hauer@pengutronix.de,
        shawn.guo@linaro.org, broonie@kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        philippe.retornaz@gmail.com
Subject: Re: [PATCH v3 3/4] ASoC: fsl_ssi: Add dual fifo mode support
References: <cover.1383207153.git.b42378@freescale.com> <da997ce67d9817364248ca1eba716bb6c7814a24.1383207153.git.b42378@freescale.com>
In-Reply-To: <da997ce67d9817364248ca1eba716bb6c7814a24.1383207153.git.b42378@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolin Chen wrote:
> +	if (ssi_private->use_dual_fifo) {
> +		write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
> +		write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
> +		write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
> +	} else {
> +		write_ssi_mask(&ssi->srcr, CCSR_SSI_SRCR_RFEN1, 0);
> +		write_ssi_mask(&ssi->stcr, CCSR_SSI_STCR_TFEN1, 0);
> +		write_ssi_mask(&ssi->scr, CCSR_SSI_SCR_TCH_EN, 0);
> +	}

Why do you need the "else" part?  Why can't you just do this:

if (ssi_private->use_dual_fifo) {
	write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
	write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
	write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
}

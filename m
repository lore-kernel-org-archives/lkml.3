Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaIIThq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:37:46 -0400
Received: from muin.pair.com ([209.68.1.55]:55383 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaIIThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:37:45 -0400
Message-ID: <540F5706.1050303@tabi.org>
Date: Tue, 09 Sep 2014 14:37:42 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Shengjiu Wang <shengjiu.wang@freescale.com>, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com> <20140909183804.GA6944@Asurada>
In-Reply-To: <20140909183804.GA6944@Asurada>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 01:38 PM, Nicolin Chen wrote:
> make sure to have the call for imx only because it seems that
> the other platforms do not depend on the clock.

Although I doubt anyone will every add support for clocks to PowerPC 
"side" of this driver, I would prefer to avoid IMX-specific changes. 
Instead, the code should check if a clock is available.  That's why I 
suggested this change:

-	if (ssi_private->soc->imx)
+	if (!IS_ERR(ssi_private->clk))

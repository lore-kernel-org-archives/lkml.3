Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaIIUhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:37:46 -0400
Received: from muin.pair.com ([209.68.1.55]:54920 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaIIUh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:37:28 -0400
Message-ID: <540F6506.4060302@tabi.org>
Date: Tue, 09 Sep 2014 15:37:26 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Shengjiu Wang <shengjiu.wang@freescale.com>, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com> <20140909183804.GA6944@Asurada> <540F5706.1050303@tabi.org> <20140909195928.GA5224@Asurada> <540F5D29.7040309@tabi.org> <20140909202710.GB5224@Asurada>
In-Reply-To: <20140909202710.GB5224@Asurada>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 03:27 PM, Nicolin Chen wrote:
> I guess Mark's comment is merely against the check for clk validation
> because if talking about clk validation, we should check IS_ERR(clk)
> rather than check !=NULL directly.

Ah, that makes sense now.

> However, my approach doesn't need any check. The open() or pm_resume()
> can just call clk_prepare_enable() directly. The __clk_enable() will
> then handle the 'clk == NULL' case:

Yes, I was thinking the same thing.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbaIIPYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:24:06 -0400
Received: from muin.pair.com ([209.68.1.55]:49505 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbaIIPYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:24:04 -0400
Message-ID: <540F1B90.702@tabi.org>
Date: Tue, 09 Sep 2014 10:24:00 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Shengjiu Wang <shengjiu.wang@freescale.com>, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com> <540EFDFF.7050804@tabi.org> <20140909152114.GA2601@sirena.org.uk>
In-Reply-To: <20140909152114.GA2601@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 10:21 AM, Mark Brown wrote:
>> if (ssi_private->clk)
>> >	clk_prepare_enable(ssi_private->clk);

> Should be a !IS_ERR() - NULL is a valid clock.

In that case, ssi_private->clk needs to be initialized to -EINVAL or 
something, so that the check works on systems that don't have any clocks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbaIQCud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:50:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:46885 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbaIQCuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:50:32 -0400
Date: Tue, 16 Sep 2014 19:50:15 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, timur@tabi.org,
        Li.Xiubo@freescale.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
Message-ID: <20140917025014.GA6048@Asurada>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
 <20140916180028.GA6784@Asurada>
 <20140917013251.GA4796@dragon>
 <20140917022440.GA3216@Asurada>
 <20140917023127.GA16456@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917023127.GA16456@dragon>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 10:31:28AM +0800, Shawn Guo wrote:
> On Tue, Sep 16, 2014 at 07:24:40PM -0700, Nicolin Chen wrote:
> > It's not supported in the clock API or just not implemented in our
> > code? Can we just register a clock without CLK_SET_RATE_PARENT to
> > achieve the purpose? (We are just trying to fix those PRED and PODF
> > dividers when the driver calls set_rate to their GATE clock.)
> 
> It seems I misunderstood your question.  Yes, if we drop flag
> CLK_SET_RATE_PARENT for the gate clock in question, the rate change
> request will not be propagated to upstream dividers.

Okay. Since there's a solution that allows us to handle it better,
problem solved then.

@Shengjiu
Would you please take a look at the clock driver to implement a
new clock register function? And make sure to register the GATE
clock only without the flag CLK_SET_RATE_PARENT, as we may still
need to set a reasonable rate for the clock by setting its PODF
clock node instead.

Thank you both
Nicolin

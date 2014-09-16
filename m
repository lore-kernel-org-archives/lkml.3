Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaIPSUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:20:16 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50225 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaIPSUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:20:15 -0400
Date: Tue, 16 Sep 2014 11:19:28 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>, shawn.guo@freescale.com
Cc: timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
Message-ID: <20140916180028.GA6784@Asurada>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 07:46:34PM +0800, Shengjiu Wang wrote:
> The spdif root clock may be used by other module or defined with
> CLK_SET_RATE_GATE, so we can't change the clock rate in driver.
> In this patch remove the clk_set_rate and clk_round_rate to protect the
> clock.

It's a quite convenient and conservative way to remove the clock
dealing code in the driver, however, it may result less flexible
functionalities.

The reason why I left the clk_set_rate() in the driver is to hope
we may find a better way to tackle those tough situations. For IP
itself, it doesn't matter if the clock the SoC provides to it is
being shared by other modules or not.

So I think, if it's a shared clock, we should not define it as a
rate-changeable one in the SoC level, as we might still have some
SoCs provide a dedicated clock to S/PDIF so as to get the maximum
range of clock support for users.

@Shawn
Sorry to involve you in this topic. I'm not so sure if we can do
this in the clock driver so that the clock rate would be fixed
even if the driver is trying to change it. If we can, I think we
may use a better solution here instead.

Thank you
Nicolin

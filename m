Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3EHQDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:03:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59376 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3EHQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:03:42 -0400
Date: Wed, 8 May 2013 18:03:32 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 4/6] ASoC: ux500: Update tx tdm slots configuration
Message-ID: <20130508160332.GB12970@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-5-git-send-email-fabio.baltieri@linaro.org>
 <20130508110149.GF7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508110149.GF7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 12:01:49PM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 09:14:19AM +0200, Fabio Baltieri wrote:
> > Update ab8500-codec and mop500_ab8500 tx slot configuration to reflect
> > the actual one used by STE.  Also update a wrong comment in the process.
> 
> This seems wrong, the individual chip drivers should just be doing
> whatever they're being told by the machine driver.  Sounds like there's
> two fixes needed here - one is to change the TDM API so that the chip
> drivers are just implementing configuration supplied by the machine
> driver and the other is to change the configuration being done to
> whatever is desired.

Ok so, this patch was really just going to slightly align the
configuration with the STE driver.  I'll drop it and just fix the wrong
comment as a trivial patch.

For the reimplementation with channel configuration from machine driver,
I actually went through that, but was not able to find the reason why
there is a slot offset somewhere (example: I request 0x0001 for first
slot on the DAI and that shows up on slot 8 on the codec), so I just
updated the hardcoded value.  I'll try to get some explanation for that.

Fabio

-- 
Fabio Baltieri

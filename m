Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbbAWI1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:27:19 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35451 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbbAWI1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:27:17 -0500
Date: Fri, 23 Jan 2015 00:27:09 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <b50113@freescale.com>
Cc: Zidan Wang <zidan.wang@freescale.com>, timur@tabi.org, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150123082708.GA3408@Alpha>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
 <20150121180801.GA3361@Alpha>
 <20150122045515.GA3467@b50113>
 <20150122054409.GA7748@Asurada>
 <20150122062004.GA7046@b50113>
 <20150122235019.GA3204@Asurada-GSX>
 <20150123025507.GA2382@b50113>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123025507.GA2382@b50113>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:55:09AM +0800, Zidan Wang wrote:
> I have another question.
> 
> Can a channel have several slots? Or channel just means slot.

Strictly speaking, a channel surely may have several slots IMO.
The idea for TDM, even for I2S, left channel can bear multiple
slots -- each may be masked and then received by a different
peripheral.

The reason I've said that much against your code is not fully
objection against your idea of using Slot Per Channel but for
the implementation -- you divided them and then multiplied them
again while your true motivation was just to calculate the bclk.
And I could not understand it without seeing your later explain.
Code and things would be much easier if you make it straight
forward.

But actually I don't mind if you feel comfortable to make a
detour like that, but as I commented at the first place. Code
like that should be companied with comments to tell its meaning.
And I still don't fully understand why you override the channels
for monaural cases.

> > And another problem of your patch is the configurations for FRSZ and
> > xMR fields. For monaural case, the channels == 1, the current code
> > passes it directly to set them while your code overrides it to 2.
> > 
> > I'm not sure if you've tested the monaural case and confirmed it works.
> > But, apparently, the configurations look pretty different.

> I have tested the mono case, it works well.

I just ran a simple test with speaker-test -Dhw:0 -c1, it works
but the FRSZ value is changed to 0x1 for a monaural case (0x0
originally). Setting FRSZ to 0x0 makes more sense to me since
it looks like the configuration for active slot number. But
that depends on the internal logic design of SAI so it may be
better for you to double check with IC owner and run more tests.
If you confirm that, I for sure will be willing to ignore the
change here.

Nicolin

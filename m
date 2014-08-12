Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaHLIYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:24:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbaHLIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:24:18 -0400
Date: Tue, 12 Aug 2014 09:24:16 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Peter Chan <peter.chan@freescale.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>, Mark Brown <broonie@kernel.org>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "rf@opensource.wolfsonmicro.com" <rf@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
	enable mono speaker output
Message-ID: <20140812082416.GA15833@opensource.wolfsonmicro.com>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com> <20140807165836.GL17528@sirena.org.uk> <20140808082043.GB6333@MrMyself> <39712b9fd56546f8a943d605230a2f18@BL2PR03MB371.namprd03.prod.outlook.com> <20140811131949.GA28085@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811131949.GA28085@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 02:19:49PM +0100, Charles Keepax wrote:
> On Fri, Aug 08, 2014 at 09:55:43AM +0000, Peter Chan wrote:
> > 
> > But our customer reported that they did try to set both SPKOUTR_ENA and SPKOUTL_ENA bits in mono mode but the sound is lousy. If setting SPKOUTR_ENA alone, the speaker has no sound. Only setting SPKOUTL_ENA bit get the correct speaker output in mono mode.
> 
> From the wording of "tie both outputs together" in the datasheet
> I would assume that means both should be fed the same audio? Was
> this done? I will try to give the hardware guys here a shout and
> see if I can get some clarification on mono mode on this device.

I have had a word with the hardware team here and both channels
do need to be enabled but audio should only be fed to the left
channel. So the driver definitely needs updated for the mono
case, but I am unclear as to what is causing your poor audio
quality issue.

Thanks,
Charles

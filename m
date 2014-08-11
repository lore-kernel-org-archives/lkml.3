Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaHKNTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:19:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48014 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaHKNTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:19:52 -0400
Date: Mon, 11 Aug 2014 14:19:49 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Peter Chan <peter.chan@freescale.com>
Cc: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        Mark Brown <broonie@kernel.org>, Nicolin Chen <nicoleotsuka@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rf@opensource.wolfsonmicro.com" <rf@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
	enable mono speaker output
Message-ID: <20140811131949.GA28085@opensource.wolfsonmicro.com>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com> <20140807165836.GL17528@sirena.org.uk> <20140808082043.GB6333@MrMyself> <39712b9fd56546f8a943d605230a2f18@BL2PR03MB371.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39712b9fd56546f8a943d605230a2f18@BL2PR03MB371.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 09:55:43AM +0000, Peter Chan wrote:
> I have a question about the wm8962 mono speaker mode. In SPK_MONO description at table 73, it says "When SPK_MONO is enabled, both speakers output the signal from the left channel". Does it mean only the left channel control the output in mono speaker mode?
> 
> Thanks,
> Peter
> 
> -----Original Message-----
> From: Nicolin Chen [mailto:Guangyu.Chen@freescale.com] 
> Sent: Friday, August 08, 2014 4:21 PM
> To: Mark Brown
> Cc: Nicolin Chen; alsa-devel@alsa-project.org; tiwai@suse.de; patches@opensource.wolfsonmicro.com; Wang Shengjiu-B02247; lgirdwood@gmail.com; linux-kernel@vger.kernel.org; CHAN Peter-B18700; ckeepax@opensource.wolfsonmicro.com; rf@opensource.wolfsonmicro.com
> Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to enable mono speaker output
> 
> On Thu, Aug 07, 2014 at 05:58:36PM +0100, Mark Brown wrote:
> > On Thu, Aug 07, 2014 at 07:55:49PM +0800, Nicolin Chen wrote:
> > > As WM8962 datasheet describes for SPK_MONO bit of R51: When SPK_MONO 
> > > is set to '1', both speakers output the signal from the left channel.
> > 
> > > So for mono speaker widget, we shall enable Left Channel whose 
> > > enable bit is 6 instead of 7 (Right Channel).
> > > 
> > > This patches just simply corrects the bit offset.
> > 
> > >  		   spkmixl, ARRAY_SIZE(spkmixl)),  SND_SOC_DAPM_MUX_E("Speaker 
> > > PGA", WM8962_PWR_MGMT_2, 4, 0, &spkoutl_mux,
> > >  		   out_pga_event, SND_SOC_DAPM_POST_PMU), 
> > > -SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 7, 0, 
> > > NULL, 0),
> > > +SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 6, 0, 
> > > +NULL, 0),
> > >  SND_SOC_DAPM_OUTPUT("SPKOUT"),
> > >  };
> > 
> > Someone who's name I'd need to look up submitted an identical fix off 
> > list recently - I checked the datasheet and it seems that in mono mode 
> > the speaker output actually wants both left and right channels active 
> > so there is a bug here but this isn't the fix.
> 
> I rechecked the datasheet and found that the hardware needs to tie both outputs and enable both bits. So the patch should be invalid.
> 
> But our customer reported that they did try to set both SPKOUTR_ENA and SPKOUTL_ENA bits in mono mode but the sound is lousy. If setting SPKOUTR_ENA alone, the speaker has no sound. Only setting SPKOUTL_ENA bit get the correct speaker output in mono mode.

>From the wording of "tie both outputs together" in the datasheet
I would assume that means both should be fed the same audio? Was
this done? I will try to give the hardware guys here a shout and
see if I can get some clarification on mono mode on this device.

Thanks,
Charles

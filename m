Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaHHIlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:41:05 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:46033
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258AbaHHIk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:40:59 -0400
Date: Fri, 8 Aug 2014 16:20:44 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <alsa-devel@alsa-project.org>,
        <tiwai@suse.de>, <patches@opensource.wolfsonmicro.com>,
        <b02247@freescale.com>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <B18700@freescale.com>,
        <ckeepax@opensource.wolfsonmicro.com>,
        <rf@opensource.wolfsonmicro.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
 enable mono speaker output
Message-ID: <20140808082043.GB6333@MrMyself>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
 <20140807165836.GL17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140807165836.GL17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(189002)(199002)(21056001)(97736001)(102836001)(33716001)(76482001)(44976005)(23726002)(77982001)(74662001)(31966008)(74502001)(85852003)(6806004)(46406003)(80022001)(79102001)(50466002)(83072002)(97756001)(87936001)(81342001)(81542001)(92566001)(95666004)(33656002)(86362001)(47776003)(20776003)(69596002)(83322001)(84676001)(104016003)(106466001)(26826002)(105606002)(81156004)(4396001)(107046002)(50986999)(76176999)(99396002)(92726001)(110136001)(46102001)(64706001)(54356999)(85306004)(68736004)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB381;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 05:58:36PM +0100, Mark Brown wrote:
> On Thu, Aug 07, 2014 at 07:55:49PM +0800, Nicolin Chen wrote:
> > As WM8962 datasheet describes for SPK_MONO bit of R51: When SPK_MONO
> > is set to '1', both speakers output the signal from the left channel.
> 
> > So for mono speaker widget, we shall enable Left Channel whose enable
> > bit is 6 instead of 7 (Right Channel).
> > 
> > This patches just simply corrects the bit offset.
> 
> >  		   spkmixl, ARRAY_SIZE(spkmixl)),
> >  SND_SOC_DAPM_MUX_E("Speaker PGA", WM8962_PWR_MGMT_2, 4, 0, &spkoutl_mux,
> >  		   out_pga_event, SND_SOC_DAPM_POST_PMU),
> > -SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 7, 0, NULL, 0),
> > +SND_SOC_DAPM_PGA("Speaker Output", WM8962_CLASS_D_CONTROL_1, 6, 0, NULL, 0),
> >  SND_SOC_DAPM_OUTPUT("SPKOUT"),
> >  };
> 
> Someone who's name I'd need to look up submitted an identical fix off
> list recently - I checked the datasheet and it seems that in mono mode
> the speaker output actually wants both left and right channels active so
> there is a bug here but this isn't the fix.

I rechecked the datasheet and found that the hardware needs to tie
both outputs and enable both bits. So the patch should be invalid.

But our customer reported that they did try to set both SPKOUTR_ENA
and SPKOUTL_ENA bits in mono mode but the sound is lousy. If setting
SPKOUTR_ENA alone, the speaker has no sound. Only setting SPKOUTL_ENA
bit get the correct speaker output in mono mode.

And I just confirmed with our engineer who supports the customer
that they are using the correct hardware design as the datasheet
suggests. So I'm wondering if there's any other part we're missing.

Thank you
Nicolin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaAMKs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:48:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:46118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbaAMKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:48:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,652,1384329600"; 
   d="scan'208";a="465766323"
Message-ID: <1389610131.2326.16.camel@loki>
Subject: Re: [alsa-devel] [PATCH] ASoC: dpcm: don't do hw_param when BE has
 done	hw_param
From: Liam Girdwood <liam.r.girdwood@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nenghua Cao <nhcao@marvell.com>
Date: Mon, 13 Jan 2014 10:48:51 +0000
In-Reply-To: <s5hzjn2n9ne.wl%tiwai@suse.de>
References: <1389332195-15900-1-git-send-email-nhcao@marvell.com>
	 <s5htxdcxg0q.wl%tiwai@suse.de> <52CFD7BE.5030907@marvell.com>
	 <1389354435.2293.32.camel@loki> <52CFE0AE.1030606@marvell.com>
	 <s5hk3e8xcz2.wl%tiwai@suse.de> <1389356948.2293.55.camel@loki>
	 <s5hd2k0x833.wl%tiwai@suse.de> <1389379389.2293.114.camel@loki>
	 <s5hzjn2n9ne.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 10:35 +0100, Takashi Iwai wrote:
> At Fri, 10 Jan 2014 18:43:09 +0000,
> Liam Girdwood wrote:
> > 
> > On Fri, 2014-01-10 at 14:46 +0100, Takashi Iwai wrote:
> > > At Fri, 10 Jan 2014 12:29:08 +0000,
> > > Liam Girdwood wrote:
> > > > 

> > 
> > The intention was to use the existing alsa-lib/tinyalsa PCM hw_params
> > APIs. The BE would just export itself to usespace as a PCM (but without
> > the capability for direct playback/capture - just format, rate setting)
> 
> Does it mean that, from kernel perspective, a BE creates a dedicated
> (virtual) PCM device and expose it to user-space?  Or just through
> special API?

I'm thinking a virtual PCM if you agree. 

We could keep the same userspace API for configuration OR we could
extend the API slightly to add some snd_pcm_virtual_() functions.
Extending the API would imply the virtual PCM only supports a subset of
PCM API calls (avoiding any confusion/mixing with regular PCM APIs).

Thanks

Liam    



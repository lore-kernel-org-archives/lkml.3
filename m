Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaCNJjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:39:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44547 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755724AbaCNJjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:39:33 -0400
Message-ID: <5322CE32.2000102@ti.com>
Date: Fri, 14 Mar 2014 11:38:58 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <dmaengine@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <joelf@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Tony Lindgren <tony@atomide.com>,
        <nsekhar@ti.com>, Jyri Sarha <jsarha@ti.com>, <mporter@linaro.org>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/18] edma/ASoC: dmaengine PCM for AM335x and AM447x
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com> <20140313134601.GU366@sirena.org.uk>
In-Reply-To: <20140313134601.GU366@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 03:46 PM, Mark Brown wrote:
> On Thu, Mar 13, 2014 at 11:18:22AM +0200, Peter Ujfalusi wrote:
> 
>> With this series AM335x and AM447x will use the dmaengine PCM for audio. The
>> daVinci devices will keep using the davinci-pcm for now since I do not have
>> means to test them but the code is written in a way that they can be switched
>> to use the edma-pcm easily (DA850/OMAP-L138 has been tested and audio was
>> working fine).
> 
> Can you please not resend the ASoC portions of this series until the
> EDMA portion is stable (and ideally committed)?  I'm not quite sure why
> but every EDMA patch series seems to go through lots of iterations which
> gets rather noisy - my initial reaction to seeing EDMA in a subject is
> to just delete the thread.

Sure, I'm not planning to spam alsa-devel however the switch to dmaengine PCM
for AM335x/AM447x needs the edma patches, otherwise it is not going to work.
AFAIK I have not sent patch to edma as of now so I have no idea how long it
takes to get stuff in (the good thing is that the edma part does not touch DT,
which is alone can reduce the number of iterations).
Anyway, what I can - and already did is:
Reorder the ASoC patches and I can leave out the switch to dmaengine PCM patch
for davinci-mcasp for now. The edma-pcm and the other patches for McASP can go
in right away (I will not add the edma-pcm to the Makefile/Kconfig to avoid
issues).

I will detach the edma stuff and follow it up outside of alsa-devel.

The only thing I'm afraid off is that it is going to take two release cycle to
get this in: first cycle edma part, next cycle for the ASoC to switch to use
the edma-pcm.

-- 
Péter

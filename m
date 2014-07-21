Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaGUJBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:01:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43397 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbaGUJBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:01:35 -0400
Date: Mon, 21 Jul 2014 10:01:22 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: arizona: Disable AIF TX/RX before configuring it
Message-ID: <20140721090104.GA21400@opensource.wolfsonmicro.com>
References: <20140716121029.GA22222@opensource.wolfsonmicro.com> <20140717194215.GH17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717194215.GH17528@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 08:42:15PM +0100, Mark Brown wrote:
> On Wed, Jul 16, 2014 at 01:10:39PM +0100, Richard Fitzgerald wrote:
> 
> > If we don't disable the AIF TX/RX then we may fall into a
> > situation where the new AIF settings are ignored by the device.
> > For example, this problem manifests when switching between
> > different sample rates.
> 
> So, what this does is momentarily disable the AIF when reconfiguring.
> That will glitch any running audio, making me wonder if the driver
> shouldn't be returning an error or at least complaining if it has to
> reconfigure instead.  What's the use case where this might get
> triggered?

The case being fixed is like this:

aplay 48kHz.wav; aplay 96kHz.wav

The second open happens before pmdown_time so the AIF is still enabled.
Writes to the AIF config registers only take effect if the AIF is disabled.
Without this patch, the 96kHz.wav will play at 48kHz

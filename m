Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3HMVLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:11:32 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46208 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HMVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:11:30 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 12/18] ARM: s3c64xx: Add support for DMA using generic amba-pl08x driver
Date: Tue, 13 Aug 2013 23:11:25 +0200
Message-ID: <7183441.XhIsgkmB55@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.5-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130813203536.GI6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <4262768.VLqddFvVic@flatron> <20130813203536.GI6427@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of August 2013 21:35:36 Mark Brown wrote:
> On Tue, Aug 13, 2013 at 01:10:02PM -0700, Tomasz Figa wrote:
> > On Tuesday 13 of August 2013 18:52:51 Mark Brown wrote:
> > > On Sun, Aug 11, 2013 at 07:59:24PM +0200, Tomasz Figa wrote:
> > > > +#define pl330_filter pl08x_filter_id
> > > 
> > > So, this is pretty fun and probably not going to play too nicely for
> > > multiplatform kernels...
> > 
> > Yes, this is really funny and only shows the brokenness of current
> > channel filtering mechanism used in DMA engine subsystem. Fortunately
> > this is quite irrelevant to multiplatform kernels, because no users
> > of it will be compiled in, since it's used only for legacy (non-DT)
> > channel filtering.
> Well, the thing here is more about the fact that the match function is
> silently being hijacked - it should be possible to do this in the device
> registrations.  I'd expect you could get a non-DT kernel which was
> affected, but you'd probably have to try.

Let me see what I can do to improve things for now.

> > Anyway, I would happily redesign and rewrite the DMA engine channel
> > matching completely to make it much more sane, but I guess I would
> > need an ack from Vinod and Dan to do it.
> 
> I'd be really keen to get this code merged sooner rather than later for
> ASoC development so if there's a way to do it separately to fixing the
> filtering that'd be good.

I fully agree on this. I still have other things to work on, so the 
possible redesign of channel filtering would not probably happen before 
3.12 merge window closes.

Best regards,
Tomasz


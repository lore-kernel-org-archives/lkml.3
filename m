Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab3HMUKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:10:08 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60245 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab3HMUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:10:05 -0400
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
Date: Tue, 13 Aug 2013 13:10:02 -0700 (PDT)
Message-ID: <4262768.VLqddFvVic@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.5-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130813175251.GC6427@sirena.org.uk>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <1376243970-6489-13-git-send-email-tomasz.figa@gmail.com> <20130813175251.GC6427@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 of August 2013 18:52:51 Mark Brown wrote:
> On Sun, Aug 11, 2013 at 07:59:24PM +0200, Tomasz Figa wrote:
> > +#define pl330_filter pl08x_filter_id
> 
> So, this is pretty fun and probably not going to play too nicely for
> multiplatform kernels...

Yes, this is really funny and only shows the brokenness of current channel 
filtering mechanism used in DMA engine subsystem. Fortunately this is 
quite irrelevant to multiplatform kernels, because no users of it will be 
compiled in, since it's used only for legacy (non-DT) channel filtering.

Anyway, I would happily redesign and rewrite the DMA engine channel 
matching completely to make it much more sane, but I guess I would need an 
ack from Vinod and Dan to do it.

Best regards,
Tomasz


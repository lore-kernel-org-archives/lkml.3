Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3H1IXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:23:40 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63788 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3H1IXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:23:37 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 09/18] ASoC: Samsung: Do not queue cyclic buffers multiple times
Date: Wed, 28 Aug 2013 10:23:34 +0200
Message-ID: <3566701.5anQOxoFga@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <CACRpkdZd+LJeZdSjsD6OCLOnZ0VrDg0aa-e163NXsw6ajWf7rA@mail.gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com> <1376243970-6489-10-git-send-email-tomasz.figa@gmail.com> <CACRpkdZd+LJeZdSjsD6OCLOnZ0VrDg0aa-e163NXsw6ajWf7rA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 of August 2013 09:06:27 Linus Walleij wrote:
> On Sun, Aug 11, 2013 at 7:59 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > The legacy S3C-DMA API required every period of a cyclic buffer to be
> > queued separately. After conversion of Samsung ASoC to Samsung DMA
> > wrappers somebody made an assumption that the same is needed for DMA
> > engine API, which is not true.
> > 
> > In effect, Samsung ASoC DMA code was queuing the whole cyclic buffer
> > 
> > multiple times with a shift of one period per iteration, leading to:
> >   a) severe memory waste - up to 13x times more DMA transfer
> >   descriptors
> >   
> >      are allocated than needed,
> >   
> >   b) possible memory corruption, because further cyclic buffers were
> >   out
> >   
> >      of the original buffers, due to the offset.
> > 
> > This patch fixes this problem by making the legacy S3C-DMA API use the
> > same semantics as DMA engine (the whole cyclic buffer is enqueued at
> > once) and modifying users of Samsung DMA wrappers in cyclic mode to
> > behave appropriately.
> > 
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> If patch 1 thru 9 are uncontroversial now, maybe Vinod can apply
> these for v3.12 so we can get less noise and risk of collissions
> in the next merge window?
> 
> Just an idea.

That would be nice, leaving only Samsung-specific patches for the next 
merge window.

(That would be patches 1 to 8, though, as 9 is a patch for ASoC that could 
be picked up by Mark Brown independently.)

Best regards,
Tomasz


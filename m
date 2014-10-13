Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaJMQYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:24:31 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:9906 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaJMQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:24:29 -0400
X-AuditID: cbfec372-b7f2f6d0000052b3-05-543bfcbbf44e
Date: Mon, 13 Oct 2014 18:24:23 +0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] s5p-jpeg: Only build suspend/resume for PM
Message-id: <20141013182423.39feb60f.m.chehab@samsung.com>
In-reply-to: <CAMuHMdXG1pD1-O2m1NXp6gr4aVqyqV=-x-nPoWQJMWr_0XF42w@mail.gmail.com>
References: <1412234489-1330-1-git-send-email-thierry.reding@gmail.com>
 <CAMuHMdXG1pD1-O2m1NXp6gr4aVqyqV=-x-nPoWQJMWr_0XF42w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/hEN3df6xDDC6vsrB4dmsvk8XlXXPY
	LHo2bGW1+LlrHosDi8fOWXfZPQ4d7mD0+LxJLoA5issmJTUnsyy1SN8ugSvjxNmvTAU9fBUt
	y/eyNjC+4epi5OSQEDCReH/9JSuELSZx4d56ti5GLg4hgSWMEm/3/GKHcJqZJHYvusQCUsUi
	oCrR3n4GrINNwEjiVWMLkM3BISKgKzHnJxNIPbPACkaJtmVf2EFqhAXcJSZ/W8MMYvMKWEls
	WvyCEcTmFAiW2DtjLROILSTQxyhxa7MryBwJAWeJ+Z+zIcoFJX5Mvge2lllAS2LztiZWCFte
	YvOat8wTGAVmISmbhaRsFpKyBYzMqxhFS4uTC4qT0nMN9YoTc4tL89L1kvNzNzFCQrZoB+Oz
	DVaHGAU4GJV4eC3+WIUIsSaWFVfmHmKU4GBWEuEVeWYdIsSbklhZlVqUH19UmpNafIiRiYNT
	qoGR/8rzKKF7TfFMi/ZLy1z+9vGGSErilkyrD7r+F//YXEuxrgxOt+pmmttzc7VGe+EVbcf9
	qxLDTXdtlwoQSVDoNFLZb2fhvHx14PyklMknir7d9Dyfc/Pi5XvfVvFomM/zFT5Vb5rubqJ1
	VSHCdp/w8q0Nl2eYWP2ctUKw4pO01otpxx96Gz1SYinOSDTUYi4qTgQAuReneTcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 13 Oct 2014 18:16:10 +0200
Geert Uytterhoeven <geert@linux-m68k.org> escreveu:

> On Thu, Oct 2, 2014 at 9:21 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > If power management is disabled these function become unused, so there
> > is no reason to build them. This fixes a couple of build warnings when
> > PM(_SLEEP,_RUNTIME) is not enabled.
> 
> Thanks!
> 
> Despite the availability of your patch, this build warning has
> migrated to mainline.

That's because I didn't have any time yet to backport the fixes for
3.18 and send those to -next. Also, while warnings are annoying,
a warning like that is not really an urgent matter, as gcc should
remove the dead code anyway.

I should be handling fixes next week, after my return from LinuxCon EU,
gstreamer conf, audio mini-summit and media summit. This will be a too
busy week.

> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> > --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> > +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> 
> > @@ -2681,7 +2682,9 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
> >
> >         return 0;
> >  }
> > +#endif
> 
> I'd add a comment "/* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */" here,
> as above is a big block of code.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds


-- 

Cheers,
Mauro

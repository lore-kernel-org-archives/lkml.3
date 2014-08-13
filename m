Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaHMWqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:46:24 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63112 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:46:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alim Akhtar <alim.akhtar@gmail.com>
Cc: Andrew Bresticker <abrestic@chromium.org>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: dw_mmc: Remove architecture dependency
Date: Thu, 14 Aug 2014 00:46:18 +0200
Message-ID: <1786859.jGWg0DZRp1@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGOxZ51_cr_j5vWrNO_ZnfAQsvt8zfEjQZC2f-nWv4w9b5R1kQ@mail.gmail.com>
References: <1407951153-918-1-git-send-email-abrestic@chromium.org> <CAGOxZ51_cr_j5vWrNO_ZnfAQsvt8zfEjQZC2f-nWv4w9b5R1kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MInJXwl3lAdKgFe0p1Bh0f0Wp82Wk0F/DkhudBQ+FZR
 Q4eU7OnCNa6RNG7zlsOPWCUhn54hOhN/FnaHvwkjEUPEGeT/fw
 ogX7bFnbWTQA1Z6QgujU5XofLgMfmNRscqT6GvkUWCr8XYsxyJ
 MKiOhLpPr1sXOBgc2rnBiMcIoVNLM3CAKXDUig6WOww6isvk0f
 BPv5dDUAOb+BUcnUieD5GKmpG0BNtR4InWwu7kCr7M71yTGG7G
 y3Rkd8vmMZBg/aaqYA/xknNz6MLqzymHaGVtln15m3Bkpmg4AO
 89B7VEqkAgGWMTeDclR3Gmmo5rlZl6lNzlM2UNA4/YL7Ha2gAk
 vR9weTMr4SI1KkJzZd24=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2014 03:51:43 Alim Akhtar wrote:
> On Wed, Aug 13, 2014 at 11:02 PM, Andrew Bresticker
> <abrestic@chromium.org> wrote:
> > The dw_mmc host may also be present on non-ARC/ARM SoCs (e.g. MIPS)
> > and the driver itself does not appear to depend on any particular
> > architecture(s).
> >
> > Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> > ---
> >  drivers/mmc/host/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> > index a565254..15b110a 100644
> > --- a/drivers/mmc/host/Kconfig
> > +++ b/drivers/mmc/host/Kconfig
> > @@ -563,7 +563,6 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
> >
> >  config MMC_DW
> >         tristate "Synopsys DesignWare Memory Card Interface"
> > -       depends on ARC || ARM
> 
> I am not sure if just removing _depends_ is good vs adding another
> architecture(s) dependency here.
> There are n number of places in Kconfig where this _depends_ runs up
> to well over 10 entries.
> What about config like MMC_DW_EXYNOS and MMC_DW_K3 which depends on
> MMC_DW? Is it ok to expose them as well for architectures which might
> not contains these variants?
> 
> One way I found this useful, one need not worry about finding MMC_DW
> in there arch default menu-config, this will just appear, go and
> select it.
> 
> Lets see what others think about this.

In general, it's best to have specific dependencies on the subsystem
a driver uses. You probably need something like

	depends on HAS_IOMEM && COMMON_CLK && REGULATOR
	depends on COMPILE_TEST || ARC || ARM || MIPS

to cover all the possible cases. The specific options are probably
not the ones I listed above, but you should get the idea. Most importantly,
you don't want to allow building the driver on architectures on which
it can't compile.

	Arnd

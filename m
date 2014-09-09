Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaIIXpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:45:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47722 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaIIXpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:45:15 -0400
Date: Wed, 10 Sep 2014 08:45:10 +0900
From: Simon Horman <horms@verge.net.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Wolfram Sang <wsa@sang-engineering.com>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Ulrich Hecht <ulrich.hecht@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: remove unnecessary "obj- := dummy.o" trick
Message-ID: <20140909234510.GB16682@verge.net.au>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
 <1410258381-7088-2-git-send-email-yamada.m@jp.panasonic.com>
 <20140909174337.19023.97772@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909174337.19023.97772@quantum>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 10:43:37AM -0700, Mike Turquette wrote:
> Quoting Masahiro Yamada (2014-09-09 03:26:19)
> > In these Makefiles, at least one of "obj-y" and "obj-" is non-empty,
> > hence built-in.o is always created without such a trick.
> > 
> > Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

shmobile portion:

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> 
> > ---
> > 
> >  arch/arm/plat-samsung/Makefile | 1 -
> >  drivers/clk/shmobile/Makefile  | 2 --
> >  drivers/net/wimax/Makefile     | 4 ----
> >  3 files changed, 7 deletions(-)
> > 
> > diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
> > index 5fe1750..a402262 100644
> > --- a/arch/arm/plat-samsung/Makefile
> > +++ b/arch/arm/plat-samsung/Makefile
> > @@ -8,7 +8,6 @@ ccflags-$(CONFIG_ARCH_MULTI_V7) += -I$(srctree)/$(src)/include
> >  
> >  obj-y                          :=
> >  obj-m                          :=
> > -obj-n                          := dummy.o
> >  obj-                           :=
> >  
> >  # Objects we always build independent of SoC choice
> > diff --git a/drivers/clk/shmobile/Makefile b/drivers/clk/shmobile/Makefile
> > index e002923..9aab51c8 100644
> > --- a/drivers/clk/shmobile/Makefile
> > +++ b/drivers/clk/shmobile/Makefile
> > @@ -6,5 +6,3 @@ obj-$(CONFIG_ARCH_R8A7790)              += clk-rcar-gen2.o
> >  obj-$(CONFIG_ARCH_R8A7791)             += clk-rcar-gen2.o
> >  obj-$(CONFIG_ARCH_SHMOBILE_MULTI)      += clk-div6.o
> >  obj-$(CONFIG_ARCH_SHMOBILE_MULTI)      += clk-mstp.o
> > -# for emply built-in.o
> > -obj-n  := dummy
> > diff --git a/drivers/net/wimax/Makefile b/drivers/net/wimax/Makefile
> > index 992bc02..692184d 100644
> > --- a/drivers/net/wimax/Makefile
> > +++ b/drivers/net/wimax/Makefile
> > @@ -1,5 +1 @@
> > -
> >  obj-$(CONFIG_WIMAX_I2400M)     += i2400m/
> > -
> > -# (from Sam Ravnborg) force kbuild to create built-in.o
> > -obj- := dummy.o
> > -- 
> > 1.9.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

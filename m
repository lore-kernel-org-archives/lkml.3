Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3ILOEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:04:44 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:43796 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3ILOEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:04:42 -0400
Message-ID: <1378994599.16481.4.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 1/2] ARM: msm: Add support for MSM8974 Dragonboard
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 12 Sep 2013 17:03:19 +0300
In-Reply-To: <20130911181226.GU808@joshc.qualcomm.com>
References: <1375743779-24993-1-git-send-email-rvaswani@codeaurora.org>
	 <1375780486.2725.7.camel@iivanov-dev.int.mm-sol.com>
	 <20130911181226.GU808@joshc.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Wed, 2013-09-11 at 13:12 -0500, Josh Cartwright wrote: 
> Hey Ivan-
> 
> On Tue, Aug 06, 2013 at 12:14:46PM +0300, Ivan T. Ivanov wrote:
> [..]
> > Enable low-level debug print routines to direct their
> > output to the serial port on MSM 8974 devices.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >  arch/arm/Kconfig.debug                     |    8 ++++++++
> >  arch/arm/mach-msm/board-dt-8974.c          |    2 ++
> >  arch/arm/mach-msm/include/mach/msm_iomap.h |    4 ++++
> >  3 files changed, 14 insertions(+)
> [..]
> > diff --git a/arch/arm/mach-msm/board-dt-8974.c b/arch/arm/mach-msm/board-dt-8974.c
> > index 697623e..0ce016a 100644
> > --- a/arch/arm/mach-msm/board-dt-8974.c
> > +++ b/arch/arm/mach-msm/board-dt-8974.c
> > @@ -12,6 +12,7 @@
> >  
> >  #include <linux/of_platform.h>
> >  #include <asm/mach/arch.h>
> > +#include <asm/mach/map.h>
> >  
> >  static const char * const msm8974_dt_match[] __initconst = {
> >  	"qcom,msm8974-db",
> > @@ -20,4 +21,5 @@ static const char * const msm8974_dt_match[] __initconst = {
> >  
> >  DT_MACHINE_START(MSM8974_DT, "Qualcomm MSM (Flattened Device Tree)")
> >  	.dt_compat = msm8974_dt_match,
> > +	.map_io = debug_ll_io_init,
> 
> If/when you get this patch cooked up ontop of Rohit's, changes to this
> file (renamed to board-dt.c) should not be necessary.  As of bc37324
> ("ARM: mmu: Call debug_ll_io_init if no map_io function is specified"),
> the debug ll uart mapping is setup automatically.

Thanks Josh. I am aware of this.

Regards,
Ivan


> 
> Thanks,
>   Josh
> 



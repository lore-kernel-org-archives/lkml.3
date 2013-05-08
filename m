Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3EHOvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:51:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58938 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab3EHOvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:51:53 -0400
Date: Wed, 8 May 2013 16:51:24 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        linux-doc@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        will.deacon@arm.com, Jiri Slaby <jslaby@suse.cz>,
        linux@arm.linux.org.uk, Samuel Ortiz <sameo@linux.intel.com>,
        Nicolas Pitre <nico@linaro.org>, linux-serial@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/8] ARM:global_timer: Add ARM global timer support.
Message-ID: <20130508145124.GA29391@pengutronix.de>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022260-2197-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081638.23100.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201305081638.23100.arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:48:33 up 60 days, 28 min, 17 users,  load average: 0.86, 0.81,
 0.70
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 04:38:22PM +0200, Arnd Bergmann wrote:
> On Wednesday 08 May 2013, Srinivas KANDAGATLA wrote:
> > From: Stuart Menefy <stuart.menefy@st.com>
> > 
> > This is a simple driver for the global timer module found in the Cortex
> > A9-MP cores from revision r1p0 onwards. This should be able to perform
> > the functions of the system timer and the local timer in an SMP system.
> > 
> > The global timer has the following features:
> >     The global timer is a 64-bit incrementing counter with an
> > auto-incrementing feature. It continues incrementing after sending
> > interrupts. The global timer is memory mapped in the private memory
> > region.
> >     The global timer is accessible to all Cortex-A9 processors in the
> > cluster. Each Cortex-A9 processor has a private 64-bit comparator that
> > is used to assert a private interrupt when the global timer has reached
> > the comparator value. All the Cortex-A9 processors in a design use the
> > banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
> > Controller as a Private Peripheral Interrupt. The global timer is
> > clocked by PERIPHCLK.
> > 
> > Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
> > Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >
> 
> Are you sure we don't already have a driver for this? It sounds unlikely
> that you are the first one to do this when the hardware is so common.
> 

Isn't this the same as arch/arm/kernel/smp_twd.c ?
That is atleast the timer I used with Cortex-A9. I don't think the core
has another one. But maybe I'm wrong.

> >  Documentation/devicetree/bindings/arm/gt.txt |   21 ++
> >  arch/arm/Kconfig                             |    6 +
> >  arch/arm/include/asm/global_timer.h          |   12 +
> >  arch/arm/kernel/Makefile                     |    1 +
> >  arch/arm/kernel/global_timer.c               |  325 ++++++++++++++++++++++++++
> >  5 files changed, 365 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/arm/gt.txt
> >  create mode 100644 arch/arm/include/asm/global_timer.h
> >  create mode 100644 arch/arm/kernel/global_timer.c
> 
> Move it into drivers/clocksource?
>  
> > diff --git a/arch/arm/include/asm/global_timer.h b/arch/arm/include/asm/global_timer.h
> > new file mode 100644
> > index 0000000..46f9188
> > --- /dev/null
> > +++ b/arch/arm/include/asm/global_timer.h
> > @@ -0,0 +1,12 @@
> > +int __init global_timer_init(void __iomem *base, unsigned int timer_irq);
> 
> I don't see a need to call this from platform code for non-DT platforms, it
> can easily be used with CLOCKSOURCE_OF_DECLARE() all the time I think.
> 

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

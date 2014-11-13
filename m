Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbaKMRst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:48:49 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38135 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933619AbaKMRsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:48:47 -0500
Date: Thu, 13 Nov 2014 17:48:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: b.L: fix unmet dependency for CPU_PM
Message-ID: <20141113174837.GB4042@n2100.arm.linux.org.uk>
References: <1415857098-16928-1-git-send-email-pankaj.dubey@samsung.com>
 <alpine.LFD.2.11.1411131231060.11690@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1411131231060.11690@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 12:44:22PM -0500, Nicolas Pitre wrote:
> On Thu, 13 Nov 2014, Pankaj Dubey wrote:
> 
> > If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
> > we are getting following config warning.
> > 
> > warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
> > dependencies (SUSPEND || CPU_IDLE)
> > 
> > So BL_SWITCHER should enable CPU_PM only if either of SUSPEND or
> > CPU_IDLE is selected.
> > 
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 9d580d0..fe3d969 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1417,7 +1417,7 @@ config BL_SWITCHER
> >  	bool "big.LITTLE switcher support"
> >  	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU
> >  	select ARM_CPU_SUSPEND
> > -	select CPU_PM
> > +	select CPU_PM if (SUSPEND || CPU_IDLE)
> 
> NAK.  You just broke the code by doing this. CPU_PM is a requirement 
> here.  The dependencies for CPU_PM is lacking.

Is there any real technical reason that CPU_PM depends on SUSPEND ||
CPU_IDLE ?  If not, those dependencies should be killed.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaBPXbg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:31:36 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58851 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737AbaBPXbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:31:35 -0500
Message-ID: <1392593492.28648.11.camel@x220>
Subject: Re: [PATCH] arm: msm: remove MACH_MSM7X30_SURF
From: Paul Bolle <pebolle@tiscali.nl>
To: dwalker@fifo99.com
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 00:31:32 +0100
In-Reply-To: <20140216231407.GA18892@fifo99.com>
References: <1392572080.28866.19.camel@x220>
	 <20140216231407.GA18892@fifo99.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 23:31:32.0780 (UTC) FILETIME=[39C7E6C0:01CF2B6F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

On Sun, 2014-02-16 at 23:14 +0000, dwalker@fifo99.com wrote:
> On Sun, Feb 16, 2014 at 06:34:40PM +0100, Paul Bolle wrote:
> > The Kconfig symbol MACH_MSM7X30_SURF was added in v2.6.35. It has never
> > been used. Setting it has no effect. There are no calls for
> > machine_is_mach_msm7x30(). This symbol can safely be removed.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Tested only with "git grep".
> > 
> >  arch/arm/mach-msm/Kconfig | 7 -------
> >  1 file changed, 7 deletions(-)
> > 
> > diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> > index 9625cf3..dab941a 100644
> > --- a/arch/arm/mach-msm/Kconfig
> > +++ b/arch/arm/mach-msm/Kconfig
> > @@ -62,7 +62,6 @@ config ARCH_MSM7X30
> >  	select ARCH_MSM_SCORPION
> >  	select CPU_V7
> >  	select GPIO_MSM_V1
> > -	select MACH_MSM7X30_SURF # if !
> >  	select MSM_GPIOMUX
> >  	select MSM_PROC_COMM
> >  	select MSM_SMD
> > @@ -115,12 +114,6 @@ config MACH_TROUT
> >  	help
> >  	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> >  
> > -config MACH_MSM7X30_SURF
> > -	depends on ARCH_MSM7X30
> > -	bool "MSM7x30 SURF"
> > -	help
> > -	  Support for the Qualcomm MSM7x30 SURF eval board.
> > -
> 
> 
> It's not really enough .. There are support files for this platform, if you remove it you need to remove
> those files also. You could also go the other way and connect the config option to those files.

What support files are you thinking about here?

(Note that I need to rethink this patch anyway. The discussion about the
patch that removes MACH_MXLADS showed me that machine_is_mach_msm7x30()
is used in a more subtle way than I remembered. I hope to revisit this
and similar patches in a few days to review them myself.)

Thanks,


Paul Bolle


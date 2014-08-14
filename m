Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbaHNHkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:40:49 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49799 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbaHNHks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:40:48 -0400
Date: Thu, 14 Aug 2014 08:40:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: santosh.shilimkar@ti.com, will.deacon@arm.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, damm@opensource.se,
        ard.biesheuvel@linaro.org, olof@lixom.net, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use 'model' property to set machine_name from
	Device Tree
Message-ID: <20140814074023.GR30401@n2100.arm.linux.org.uk>
References: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com> <53EC0B2A.2070308@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EC0B2A.2070308@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 10:04:42AM +0900, Chanwoo Choi wrote:
> On 07/07/2014 10:53 AM, Chanwoo Choi wrote:
> > This patch use 'model' property from Device Tree to set machine_name.
> > The arm64 has already got the machine_name from Device Tree.
> > 
> > Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> > ---
> >  arch/arm/kernel/setup.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 8a16ee5..698616f 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -878,7 +878,11 @@ void __init setup_arch(char **cmdline_p)
> >  	if (!mdesc)
> >  		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
> >  	machine_desc = mdesc;
> > +#if CONFIG_OF
> > +	machine_name = of_flat_dt_get_machine_name();
> > +#else
> >  	machine_name = mdesc->name;
> > +#endif
> >  
> >  	if (mdesc->reboot_mode != REBOOT_HARD)
> >  		reboot_mode = mdesc->reboot_mode;
> > 
> 
> Ping.

This has come up before, and the decision was against exposing this.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

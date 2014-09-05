Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaIEMNw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:13:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44250 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932083AbaIEMNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:13:47 -0400
Date: Fri, 5 Sep 2014 13:13:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140905121316.GI30401@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <201409051338.40988@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409051338.40988@pali>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:38:40PM +0200, Pali Rohár wrote:
> On Wednesday 18 June 2014 18:54:24 Pali Rohár wrote:
> > Machine name from board description is some generic name on DT
> > kernel. DT provides machine name property which is specific
> > for board, so use it instead generic one when possible.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> >  arch/arm/kernel/setup.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 8a16ee5..fbc7b4f 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -875,10 +875,13 @@ void __init setup_arch(char **cmdline_p)
> > 
> >  	setup_processor();
> >  	mdesc = setup_machine_fdt(__atags_pointer);
> > -	if (!mdesc)
> > +	if (mdesc)
> > +		machine_name = of_flat_dt_get_machine_name();
> > +	else
> >  		mdesc = setup_machine_tags(__atags_pointer,
> > __machine_arch_type); machine_desc = mdesc;
> > -	machine_name = mdesc->name;
> > +	if (!machine_name)
> > +		machine_name = mdesc->name;
> > 
> >  	if (mdesc->reboot_mode != REBOOT_HARD)
> >  		reboot_mode = mdesc->reboot_mode;
> 
> So, do you really want to break userspace which reading file 
> /proc/cpuinfo (after migration from boardcode --> DT)?
> 
> I still do not see reason for that. And only this one file is 
> problematic...

Sorry, I just don't give a damn about your whinging about this.  I've
made the situation perfectly clear.  Your patch will not be accepted.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

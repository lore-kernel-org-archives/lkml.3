Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaIJMqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 08:46:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55721 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIJMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 08:46:23 -0400
Date: Wed, 10 Sep 2014 14:46:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pali Roh?r <pali.rohar@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140910124615.GA466@xo-6d-61-c0.localdomain>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201409051338.40988@pali>
 <20140905121316.GI30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140905121316.GI30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-09-05 13:13:16, Russell King - ARM Linux wrote:
> On Fri, Sep 05, 2014 at 01:38:40PM +0200, Pali Rohár wrote:
> > On Wednesday 18 June 2014 18:54:24 Pali Rohár wrote:
> > > -	if (!mdesc)
> > > +	if (mdesc)
> > > +		machine_name = of_flat_dt_get_machine_name();
> > > +	else
> > >  		mdesc = setup_machine_tags(__atags_pointer,
> > > __machine_arch_type); machine_desc = mdesc;
> > > -	machine_name = mdesc->name;
> > > +	if (!machine_name)
> > > +		machine_name = mdesc->name;
> > > 
> > >  	if (mdesc->reboot_mode != REBOOT_HARD)
> > >  		reboot_mode = mdesc->reboot_mode;
> > 
> > So, do you really want to break userspace which reading file 
> > /proc/cpuinfo (after migration from boardcode --> DT)?
> > 
> > I still do not see reason for that. And only this one file is 
> > problematic...
> 
> Sorry, I just don't give a damn about your whinging about this.  I've
> made the situation perfectly clear.  Your patch will not be accepted.

Linus made it pretty clear that regressions are not accepted. 

You are an arm maintainer and there is regression in n900 that broke userspace.

How do you solve it?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

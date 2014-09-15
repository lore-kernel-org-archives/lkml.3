Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaIORIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:08:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50188 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaIORIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:08:49 -0400
Date: Mon, 15 Sep 2014 09:09:02 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 06/18] ARM64 / ACPI: Introduce early_param for "acpi"
Message-ID: <20140915160902.GA6504@localhost>
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org>
 <1410530416-30200-7-git-send-email-hanjun.guo@linaro.org>
 <20140915062824.GB26649@localhost>
 <20140915145106.GC5415@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915145106.GC5415@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 03:51:07PM +0100, Catalin Marinas wrote:
> On Mon, Sep 15, 2014 at 07:28:24AM +0100, Olof Johansson wrote:
> > On Fri, Sep 12, 2014 at 10:00:04PM +0800, Hanjun Guo wrote:
> > >  			See also Documentation/power/runtime_pm.txt, pci=noacpi
> > >  
> > > diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> > > index 9252f72..693da7f 100644
> > > --- a/arch/arm64/kernel/acpi.c
> > > +++ b/arch/arm64/kernel/acpi.c
> > > @@ -67,3 +67,18 @@ void __init acpi_boot_table_init(void)
> > >  	if (acpi_table_init())
> > >  		disable_acpi();
> > >  }
> > > +
> > > +static int __init parse_acpi(char *arg)
> > > +{
> > > +	if (!arg)
> > > +		return -EINVAL;
> > > +
> > > +	/* "acpi=off" disables both ACPI table parsing and interpreter */
> > > +	if (strcmp(arg, "off") == 0)
> > > +		disable_acpi();
> > > +	else
> > > +		return -EINVAL;	/* Core will print when we return error */
> > 
> > For symmetry, you should handle acpi=force here too (i.e. if someone
> > disables by default, which I expect we'll ask for when this code is
> > first merged).
> 
> Does this mean you want another Kconfig option - ACPI_DEFAULT_OFF (which
> would be set by default)?

No, adding another config option isn't going to help anyone. Instead,
this gives us the full symmetry and option to just always by default
keep ACPI off, even if it is merged.

My argument on when ACPI should be merged is not new (i.e. once we've
seen more than just the simple system parts solved with it and solved
successfully), then we're still likely to have a transition period when
it's in tree but not enabled by default. That's what acpi=force is for,
for those who want to test with it during that time.

So, my suggestion is just there now to make sure that whichever way
we go, things will just work as expected (and the same way as on x86,
which is a goal for some).


-Olof

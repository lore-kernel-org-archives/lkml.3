Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaIAPcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:32:13 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59815 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaIAPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:32:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Graeme Gregory <graeme.gregory@linaro.org>
Cc: linaro-acpi@lists.linaro.org, Rob Herring <robh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Robert Richter <rric@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-acpi@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Linaro-acpi] [RFC PATCH for Juno 1/2] net: smsc911x add support for probing from ACPI
Date: Mon, 01 Sep 2014 17:32 +0200
Message-ID: <40491090.z7F1jbVZzH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140901152854.GJ2953@xora-haswell.xora.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org> <2861461.8zNpLC3I2n@wuerfel> <20140901152854.GJ2953@xora-haswell.xora.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UW5ZLlPq0+TJDFceRcNL4mkK7mVoV8tFy9/4b7fIZfk
 QvE5xtDVcMytdu+0lqqloXf1dt1mflEfYjIKRXmybVSZktxvsk
 wT9iHY9P1WnB2DADrkMoqpbKsK7/BYGu9t2UBLC6MZEpM4n9uS
 PEsDSpBStJrca2VNeCzDjUvzJGE2S+twrL26wnSjQbWInPpzbL
 knyJM4dXdTtrXufd49KDbRL+jp3DOnDEjed9smBalzws83gkjp
 mISsRfAZj3oMSBqXGGACJZQLbPCpJI/Da7pzX5OGYaIZJv9/yi
 XoZXljmgd0WVO+ImFRQ3MozjbdfTcHvxOajMWZLlwlyDAwNsa9
 oB5JFooSfoyAT/tYWe2Y=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 16:28:54 Graeme Gregory wrote:
> On Mon, Sep 01, 2014 at 05:17:51PM +0200, Arnd Bergmann wrote:
> > On Monday 01 September 2014 23:06:00 Hanjun Guo wrote:
> > > +#ifdef CONFIG_ACPI
> > > +/* Configure some sensible defaults for ACPI mode */
> > > +static int smsc911x_probe_config_acpi(struct smsc911x_platform_config *config,
> > > +                                   acpi_handle *ahandle)
> > > +{
> > > +       if (!ahandle)
> > > +               return -ENOSYS;
> > > +
> > > +       config->phy_interface = PHY_INTERFACE_MODE_MII;
> > > 
> > 
> > Please remove the #ifdef and use 
> > 
> >       if (!IS_ENABLED(CONFIG_ACPI) || !ahandle)
> > 
> > to check for ACPI support. This should result in the same object code
> > in all cases, but give better compile-time coverage when ACPI is
> > disabled.
> > 
> struct acpi_handle does not exist in the case !CONFIG_ACPI

That should be easy to fix, and a good idea in general, independent
of this patch.
We generally make function declarations and type definitions visible
(possibly empty) for disabled subsystems so the code using them
silently goes away when that subsystem is disabled.

	Arnd

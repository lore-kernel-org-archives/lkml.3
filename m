Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaAHNeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:34:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49281 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756456AbaAHNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:34:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6][RESEND] platform: x86: New BayTrail IOSF-SB MBI driver
Date: Wed, 08 Jan 2014 14:47:51 +0100
Message-ID: <2806157.t13m95JzXc@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140108052717.GA31745@linux.intel.com>
References: <1388427149-25456-1-git-send-email-david.e.box@linux.intel.com> <3119193.jBSlNlK309@vostro.rjw.lan> <20140108052717.GA31745@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 07, 2014 09:27:17 PM David E. Box wrote:
> On Wed, Jan 08, 2014 at 01:11:22AM +0100, Rafael J. Wysocki wrote:
> > Well, I personally think that this code should go into arch/x86/ as library code
> > needed to access IOSF Sideband on some platforms.
> 
> I don't disagree. However for the record this is not the first time it has been
> discussed and I already moved it from arch/x86 to platform on the suggestion of
> several maintainers. I will keep the interface generic except that it has to be
> stated that it will only support those platforms that can enumerate this device
> using PCI. Plus I learned there are others who plan to patch when it gets
> accepted to support other platforms using different methods of
> enumeration/communication. I would thik this probably cements its placement in
> arch/x86.

I think so.

> > I probably would make modules
> > depending on it select it, so for example if the RAPL driver is going to be
> > built, your driver should be build either and rather unconditionally in that
> > case.
> > 
> 
> Wouldn't such a dependency be handled by the RAPL driver et al. How can I force
> modules to build this driver? Reverse dependency? Also the biggest consumer of
> the driver doesn't have code upstream yet.

The modules depending on your driver can do

	select INTEL_BAYTRAIL_MBI

in their Kconfig entries.  That will cause it to be built.

> > So the rule should be "if something *may* need it, build it" in my opinion.
> 
> You suggest that even though non-IOSF systems don't need this driver to enable
> RAPL, it should build anyway since it's a dependency for systems that do have
> IOSF? Even if this is what you suggest I'd prefer the owner of the driver that
> has the dependency be the one to patch this driver to make in build in that
> case. I do not know all who would use it.

Simply, don't enable it by default and let its users do the above.

Then, they won't have to do any #ifdef CONFIG_INTEL_BAYTRAIL_MBI stuff in their
code (I'd change the name of the CONFIG_ thing if it goes beyond BayTrail).

Of course, it will be compiled for generic x86 kernels this way, but since
they have to assume they may run on anything, they'll have to build it anyway.

The only "problematic" case will be kernels compiled by users of systems that
don't use IOSF Sideband and do use things like RAPL, but I really wouldn't
try to optimize for that case.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

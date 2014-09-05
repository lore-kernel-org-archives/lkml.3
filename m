Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaIEKqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:46:10 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:52838
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756364AbaIEKqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:46:08 -0400
Date: Fri, 5 Sep 2014 12:45:47 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Robert Richter <rric@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Radha Mohan Chintakuntla <rchintakuntla@cavium.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] arm64, thunder: Add Kconfig option for Cavium
 Thunder SoC Family
Message-ID: <20140905104547.GT4703@rric.localhost>
References: <1409903205-2762-1-git-send-email-rric@kernel.org>
 <1409903205-2762-2-git-send-email-rric@kernel.org>
 <20140905093239.GC30401@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140905093239.GC30401@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.199.72]
X-ClientProxiedBy: DBXPR04CA003.eurprd04.prod.outlook.com (10.255.191.151) To
 BLUPR0701MB803.namprd07.prod.outlook.com (10.141.253.24)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(6069001)(24454002)(51704005)(189002)(199003)(105586002)(81342001)(50466002)(102836001)(85306004)(86362001)(95666004)(23726002)(19580405001)(90102001)(19580395003)(83322001)(101416001)(80022001)(64706001)(79102001)(106356001)(110136001)(66066001)(47776003)(20776003)(81542001)(76176999)(97756001)(107046002)(33656002)(77982001)(74502001)(21056001)(92566001)(54356999)(50986999)(31966008)(83072002)(99396002)(74662001)(87976001)(85852003)(4396001)(92726001)(46102001)(46406003)(76482001)(42186005)(575784001)(76506005)(77096002)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR0701MB803;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.09.14 10:32:40, Russell King - ARM Linux wrote:
> On Fri, Sep 05, 2014 at 09:46:42AM +0200, Robert Richter wrote:
> > From: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > 
> > Increase maximum numbers of cpus to 32. This relates to current
> > maximal possible cpu number. Increasing this to 64 cpus will be a
> > separate patch not part of this enablement patches.
> > 
> > Signed-off-by: Radha Mohan Chintakuntla <rchintakuntla@cavium.com>
> > Signed-off-by: Robert Richter <rrichter@cavium.com>
> > ---
> >  arch/arm64/Kconfig | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index fd4e81a4e1ce..77fb82b0f684 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -134,6 +134,11 @@ source "kernel/Kconfig.freezer"
> >  
> >  menu "Platform selection"
> >  
> > +config ARCH_THUNDER
> > +	bool "Cavium Inc. Thunder SoC Family"
> > +	help
> > +	  This enables support for Cavium's Thunder Family of SoCs.
> > +
> >  config ARCH_VEXPRESS
> >  	bool "ARMv8 software model (Versatile Express)"
> >  	select ARCH_REQUIRE_GPIOLIB
> > @@ -256,6 +261,7 @@ config NR_CPUS
> >  	range 2 32
> >  	depends on SMP
> >  	# These have to remain sorted largest to smallest
> > +	default "32" if ARCH_THUNDER
> >  	default "8"
> 
> Why do you need ARCH_THUNDER?  If it's just to change this default,

No, we need it just to enable all our drivers on the SoC. We want to
enable the SoC by using defconfig + ARCH_THUNDER. As said in my other
mail, I put it here to be able to base all other thunder driver patch
sets on this initial base patch set. Otherwise this particular patch
and also the dtb patch need to be shipped with all other driver patch
sets. This might lead to duplicate submissions of the same patch.

With doing defconfig + ARCH_THUNDER we also want to enable the max
number of cpus that is currently supported. I only enable 32 cpus
since booting more cpus is untested. There might be problems at the 32
cpu boundary. Just setting it to 64 does not mean a kernel will
actually boot more than 32 cpus. But if it will be ack'ed, I would be
fine to set NR_CPUS to 32 or 64 in general and independent from
ARCH_THUNDER.

For simplicity I better drop setting NR_CPUS in this patch.

-Robert

> please don't bother - we don't do this kind of thing on x86, so why
> should it be done here?  Just ensure that NR_CPUS is appropriately
> adjusted.  Alternatively, look at how x86 deals with this (with
> X86_BIGSMP / MAXSMP).

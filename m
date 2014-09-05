Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbaIELjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:39:09 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52479 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963AbaIELjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:39:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>, Paul Bolle <pebolle@tiscali.nl>,
        Arnd Bergmann <arnd@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        Martin Walch <walch.martin@web.de>,
        spear-devel <spear-devel@list.st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Subject: Re: [PATCH v2] ARM: spear: Remove references to PLAT_SPEAR_SINGLE
Date: Fri, 05 Sep 2014 13:38:23 +0200
Message-ID: <2863474.Iz36QDfM80@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpomS5TrG0eU51N-Pu2jE-ZVioNHz-U_7Y-mfFSUU+As-MQ@mail.gmail.com>
References: <1392153676.14317.8.camel@x220> <1409910654.5546.161.camel@x220> <CAKohpomS5TrG0eU51N-Pu2jE-ZVioNHz-U_7Y-mfFSUU+As-MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Zg2+kFu9RWoKcGMX0U20DElUFgeWTRTamTiv4HxoqMF
 bRwZElnXVJ/xcYTanIuxm/DrHvdATJtxZgLSMDsoDOIa+w5VT2
 0Wefy7FhZ4khMhcqpp6ZLeo6ITZEOcfsDTCo4N86pSFPrTobEJ
 rZcnRAYcL0QtrUkIA9QnJ4/NsS0OBI92bOmC/p6X0NJetGAF/h
 tuX3JcMwhd8RXcRczSWXri0PD+8L8Ej6J9se4SzWLl7waKGcRn
 f1GCWsy6A0JnEV6x2jhds4KlFO7DUITvAVoFrSt9x7vuIbTrYe
 xxXqFexT7f59nQ1t/avnANm/FpjNd9Es+iZdWGnOO+UDjDqUYh
 vlnjFTey7DxPnatSU9I4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 15:24:31 Viresh Kumar wrote:
> On 5 September 2014 15:20, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Fri, 2014-09-05 at 15:13 +0530, Viresh Kumar wrote:
> >> On Fri, Sep 5, 2014 at 3:09 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> >> Ditto for v3.17-rc3 and next-20140904. Could someone please pix this up?
> >>
> >> You need to send it to arm@kernel.org..
> >
> > Will do, no problem. But why actually? (Note that MAINTAINERS is silent
> > on arm@kernel.org. Maybe that address is documented elsewhere.)
> 
> Don't know where it is documented.
> 
> @Arnd: ??

We have avoided documenting it so far, to avoid getting spammed with trivial
patches that should get picked up by the subarch maintainers instead.

I've applied this patch to the next/fixes-non-critical branch now, with minor
fixup for a conflict that has come in. See below for the final version.

	Arnd

---
commit 3b0b8ec99aadea710f3dece74c95523463c0087a
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Tue Apr 15 10:26:47 2014 +0200

    ARM: spear: Remove references to PLAT_SPEAR_SINGLE
    
    The Kconfig symbol PLAT_SPEAR_SINGLE briefly appeared during the v3.10
    development cycle. It was removed in a merge commit before v3.10. A few
    references to it were left in the tree, probably because they didn't
    generate merge conflicts. Whatever it was, they're useless now and can
    safely be removed.
    
    Reported-by: Martin Walch <walch.martin@web.de>
    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Reviewed-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
    Cc: Rajeev Kumar <rajeev_kumar@mentor.com>
    Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index 6fd4dc88160b..b6f4bda273b3 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig PLAT_SPEAR
 	bool "ST SPEAr Family" if ARCH_MULTI_V7 || ARCH_MULTI_V5
-	default PLAT_SPEAR_SINGLE
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
 	select CLKSRC_MMIO
@@ -13,7 +12,7 @@ if PLAT_SPEAR
 
 config ARCH_SPEAR13XX
 	bool "ST SPEAr13xx"
-	depends on ARCH_MULTI_V7 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V7
 	select ARM_GIC
 	select GPIO_SPEAR_SPICS
 	select HAVE_ARM_SCU if SMP
@@ -44,7 +43,7 @@ endif #ARCH_SPEAR13XX
 
 config ARCH_SPEAR3XX
 	bool "ST SPEAr3xx"
-	depends on ARCH_MULTI_V5 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V5
 	depends on !ARCH_SPEAR13XX
 	select ARM_VIC
 	select PINCTRL
@@ -75,7 +74,7 @@ endif
 
 config ARCH_SPEAR6XX
 	bool "ST SPEAr6XX"
-	depends on ARCH_MULTI_V5 || PLAT_SPEAR_SINGLE
+	depends on ARCH_MULTI_V5
 	depends on !ARCH_SPEAR13XX
 	select ARM_VIC
 	help
@@ -88,7 +87,7 @@ config MACH_SPEAR600
 	  Supports ST SPEAr600 boards configured via the device-tree
 
 config ARCH_SPEAR_AUTO
-	def_bool PLAT_SPEAR_SINGLE
+	bool
 	depends on !ARCH_SPEAR13XX && !ARCH_SPEAR6XX
 	select ARCH_SPEAR3XX
 


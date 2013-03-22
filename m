Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422711Ab3CVR33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:29:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42306 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422663Ab3CVR32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:29:28 -0400
Date: Fri, 22 Mar 2013 17:29:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>, Alexander Shiyan <shc_work@mail.ru>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/5] ARM: ux500: Add machine support for ccu8540
Message-ID: <20130322172911.GH4977@n2100.arm.linux.org.uk>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org> <20130322172346.GG4977@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322172346.GG4977@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 05:23:46PM +0000, Russell King - ARM Linux wrote:
> On Fri, Mar 22, 2013 at 03:27:41PM +0000, Lee Jones wrote:
> > diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
> > index 831e1fd..1c9d0be 100644
> > --- a/arch/arm/tools/mach-types
> > +++ b/arch/arm/tools/mach-types
> > @@ -1204,3 +1204,4 @@ baileys			MACH_BAILEYS		BAILEYS			4169
> >  familybox		MACH_FAMILYBOX		FAMILYBOX		4170
> >  ensemble_mx35		MACH_ENSEMBLE_MX35	ENSEMBLE_MX35		4171
> >  sc_sps_1		MACH_SC_SPS_1		SC_SPS_1		4172
> > +u8540			MACH_U8540		U8540			4211
> 
> If you need this updated, please ask. :)

Sigh.  So...

commit 1c3a918f78b72fb60fcc9ca9a4cebc90de570e58
Author: Alexander Shiyan <shc_work@mail.ru>
Date:   Tue Aug 21 20:59:32 2012 +0400

    ARM: clps711x: Remove board support for CEIVA
    
    The current kernel does not fit in the CEIVA ROM. Also, some functional
    has already been removed due migrate from 2.6 to 3.0, and it seems that
    no one uses this platform. So, remove support for this board and modules
    specific only to this board.
    
    Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 2997e56..ae87c5e 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -66,7 +66,6 @@ iq80321                       ARCH_IQ80321            IQ80321                 169
 ks8695                 ARCH_KS8695             KS8695                  180
 karo                   ARCH_KARO               KARO                    190
 smdk2410               ARCH_SMDK2410           SMDK2410                193
-ceiva                  ARCH_CEIVA              CEIVA                   200
 voiceblue              MACH_VOICEBLUE          VOICEBLUE               218
 h5400                  ARCH_H5400              H5400                   220
 omap_innovator         MACH_OMAP_INNOVATOR     OMAP_INNOVATOR          234

commit d684f05f2d55655eee93d86974e9271010aaed09
Author: Roland Stigge <stigge@antcom.de>
Date:   Sun Aug 26 16:30:37 2012 +0200

    ARM: mach-pnx4008: Remove architecture
    
    This patch removes the ARM architecture mach-pnx4008. No direct support or user
    feedback since 2006. Acknowledgements from NXP/Philips and Linux arm-soc
    maintainers.
    
    Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 2997e56..7bc7948 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -158,7 +158,6 @@ edb9315a            MACH_EDB9315A           EDB9315A                772
 stargate2              MACH_STARGATE2          STARGATE2               774
 intelmote2             MACH_INTELMOTE2         INTELMOTE2              775
 trizeps4               MACH_TRIZEPS4           TRIZEPS4                776
-pnx4008                        MACH_PNX4008            PNX4008                 782
 cpuat91                        MACH_CPUAT91            CPUAT91                 787
 iq81340sc              MACH_IQ81340SC          IQ81340SC               799
 iq81340mc              MACH_IQ81340MC          IQ81340MC               801

And guess what my update to this file is about to do?

diff --git a/arch/arm/tools/mach-types b/arch/arm/tools/mach-types
index 831e1fd..a10297d 100644
--- a/arch/arm/tools/mach-types
+++ b/arch/arm/tools/mach-types
@@ -16,7 +16,7 @@
 # are merged into mainline or have been edited in the machine database
 # within the last 12 months.  References to machine_is_NAME() do not count!
 #
-# Last update: Thu Apr 26 08:44:23 2012
+# Last update: Fri Mar 22 17:24:50 2013
 #
 # machine_is_xxx       CONFIG_xxxx             MACH_TYPE_xxx           number
 #
@@ -64,8 +64,8 @@ h7201                 ARCH_H7201              H7201                   161
 h7202                  ARCH_H7202              H7202                   162
 iq80321                        ARCH_IQ80321            IQ80321                 169
 ks8695                 ARCH_KS8695             KS8695                  180
-karo                   ARCH_KARO               KARO                    190
 smdk2410               ARCH_SMDK2410           SMDK2410                193
+ceiva                  ARCH_CEIVA              CEIVA                   200
 voiceblue              MACH_VOICEBLUE          VOICEBLUE               218
 h5400                  ARCH_H5400              H5400                   220
 omap_innovator         MACH_OMAP_INNOVATOR     OMAP_INNOVATOR          234
...
@@ -157,9 +161,11 @@ edb9315a           MACH_EDB9315A           EDB9315A                772
 stargate2              MACH_STARGATE2          STARGATE2               774
 intelmote2             MACH_INTELMOTE2         INTELMOTE2              775
 trizeps4               MACH_TRIZEPS4           TRIZEPS4                776
+pnx4008                        MACH_PNX4008            PNX4008                 782
 cpuat91                        MACH_CPUAT91            CPUAT91                 787
 iq81340sc              MACH_IQ81340SC          IQ81340SC               799
 iq81340mc              MACH_IQ81340MC          IQ81340MC               801
...

As I've said before, do _not_ remove entries from this file because
they _will_ get replaced when it gets updated from the website version.

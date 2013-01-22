Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3AVVUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:20:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab3AVVU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:20:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 3/6] arm: kconfig: don't select TWD with local timer for Armada 370/XP
Date: Tue, 22 Jan 2013 21:19:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Matt Sealey <matt@genesi-usa.com>, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>, Ike Pan <ike.pan@canonical.com>,
        John Stultz <johnstul@us.ibm.com>, David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Nadav Haklai <nadavh@marvell.com>,
        Jon Masters <jcm@redhat.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        Chris Van Hoof <vanhoof@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>, Maen Suleiman <maen@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>
References: <1358790842-2986-1-git-send-email-gregory.clement@free-electrons.com> <201301212044.41865.arnd@arndb.de> <50FEFAB9.4030503@gmail.com>
In-Reply-To: <50FEFAB9.4030503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301222119.23750.arnd@arndb.de>
X-Provags-ID: V02:K0:vdBG95xlEwyWv+saLGaJ6DN2SLFr9y9xhYvogZ4jJ4p
 tGwuQpO2Lr6Yp8KCXqXL4izbA6YzSi/ADTt9EOq3P1CsVl7KL+
 abj3/HkfSHqve4THvwzxG7JQZ4lp1H3ziai2Ios3FQVksMt7/0
 HthWFwjW1ydeJGY8+yl+pHgB9Bo3OWow7mydq6rtr4FEE7Mlg4
 0xPxhs/Np30wivkNEgVd4H/NrLbB0W4axI6rcWJTa5rGnNowrD
 oiFg36uGKg4nRbpv84AO2VRdVZQaO/2ph9CLs4q4XZYWQZ802F
 QEJJHPbvSdTevhnz1NH+t4x0hAACsDMXnCwr4SRbstyPXkf1Y0
 TVe+eb+BGSwhzttrTpsA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Rob Herring wrote:
> No, I expect all future platforms will have architected timers. TWD is
> pretty much A9 and A5 only I believe. Same with SCU. I've probably
> missed some in my list.

Ah, I was incorrectly assuming that TWD was referring to the architected
timers, sorry about that.

Maybe we should do this differently then and do the more logical

config LOCAL_TIMERS
	bool

config ARM_TWD
	bool "ARM TWD local timer"
	depends on SMP && CPU_V7
	select LOCAL_TIMERS

config EXYNOS4_MCT
	bool "Samsung Exynos4 MCT Timer"
	depends on SMP && ARCH_EXYNOS
	select LOCAL_TIMERS

config MSM_LOCAL_TIMER
	bool "Qualcomm MSM Local Timer"
	depends on SMP && ARCH_MSM
	select LOCAL_TIMERS

That way we have no implicit assumptions. Everything will still work if you
disable local timers, but of course we will enable them in the defconfigs.

	Arnd

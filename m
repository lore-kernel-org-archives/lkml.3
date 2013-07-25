Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3GYQNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:13:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45378 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3GYQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:13:39 -0400
Date: Thu, 25 Jul 2013 09:13:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, Barry Song <baohua.song@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Remove ARM local timer API
Message-ID: <20130725161337.GA29694@codeaurora.org>
References: <20130625200211.GA11625@codeaurora.org>
 <CAOesGMj5AZcB7-kcS8_JqfKAg_RUKqTdDZf7bdwkebn3pwADAw@mail.gmail.com>
 <20130723234040.GB27761@codeaurora.org>
 <CAOesGMiornt0twdQv=tYMtAX56Lc79MVyNrHaK1nWpOk189dDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiornt0twdQv=tYMtAX56Lc79MVyNrHaK1nWpOk189dDA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Olof Johansson wrote:
> On Tue, Jul 23, 2013 at 4:40 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > On 07/23, Olof Johansson wrote:
> 
> >> Merged in as localtimer/removal into next/cleanup.
> >>
> >> I had quite a few merge conflicts due to the __cpuinit removal, so
> >> please double-check my resolutions.
> >>
> >
> > A __cpuinit is leftover in smp_twd.c. Hopefully you can just
> > redo the merge?
> 
> Done, thanks for catching it. I thought I grepped for them but I
> somehow missed that one. Fixed now.
> 

Also I think a HAVE_CAN_FLEXCAN if CAN was dragged in to
arch/arm/mach-imx/Kconfig. Here's a patch.

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 21fa9fa..1303e33 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -794,7 +794,6 @@ config SOC_IMX6Q
 	select CPU_V7
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
-	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_ANATOP
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

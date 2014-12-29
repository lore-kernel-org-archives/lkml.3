Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaL2IfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 03:35:03 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:63355 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2IfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:35:00 -0500
Date: Mon, 29 Dec 2014 09:35:09 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] clocksource: arch_timer: Fix arm64 platforms not booting
Message-ID: <20141229083509.GC29460@cbox>
References: <1419776431-26217-1-git-send-email-christoffer.dall@linaro.org>
 <71346397bb3c0e654aa5b634328ae29c@www.loen.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71346397bb3c0e654aa5b634328ae29c@www.loen.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 09:46:20PM +0000, Marc Zyngier wrote:
> On 2014-12-28 14:20, Christoffer Dall wrote:
> >Commit 0b46b8a718c6e ("clocksource: arch_timer: Fix code to...")
> >fixes
> >timer issues with certain ARMv7 platforms, but unfortunately breaks
> >arm64 platforms with hyp mode (EL2) enabled.
> >
> >The commit only sets arch_timer_use_virtual to false under
> >CONFIG_ARM,
> >but forgets that the config variable is also set in other code paths
> >(actually, right underneath the check in the patch) with detrimental
> >consequences as we've now introduced a direct early call to BUG() on
> >practically all arm64 platforms.
> >
> >One could argue that this code could be refactored to use different
> >variables for checking which *timer* to use and which *counter* to
> >use,
> >which seems to be the desired difference between ARM and arm64 in
> >this
> >case, but this approach fixes an urgent issue for now.
> >
> >Cc: Sonny Rao <sonnyrao@chromium.org>
> >Cc: Catalin Marinas <catalin.marinas@arm.com>
> >Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> >Cc: Olof Johansson <olof@lixom.net>
> >Cc: Mark Rutland <mark.rutland@arm.com>
> >Cc: Catalin Marinas <catalin.marinas@arm.com>
> >Cc: Marc Zyngier <marc.zyngier@arm.com>
> >Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >---
> >This was apparently already discovered by Yingjoe Chen in this thread
> >https://lkml.org/lkml/2014/11/24/41 and Catalin recommended a similar
> >fix.
> 
> I'm increasingly worried about the time it takes to get such critical
> fixes into the tree (arm64 is *dead* without it).
> 
> What is holding this patch which, as far as I remember, has been posted
> by Catalin almost three weeks ago?
> 
I didn't find that since I didn't think I'd have to go back that long on
lakml for something that breaks boot of an entire architecture.  Sorry
for the confusion of a second patch, but fwiw, I now spent another few
hours bisecting this, so I would really like to see this fix go into
mainline ASAP as well to save others the trouble.

Thanks,
-Christoffer

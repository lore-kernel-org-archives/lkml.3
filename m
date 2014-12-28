Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaL1Vqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 16:46:34 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:51940 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbaL1Vqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 16:46:31 -0500
To: Christoffer Dall <christoffer.dall@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] clocksource: =?UTF-8?Q?arch=5Ftimer=3A=20Fix=20arm=36?=  =?UTF-8?Q?=34=20platforms=20not=20booting?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 28 Dec 2014 21:46:20 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Sonny Rao <sonnyrao@chromium.org>
Organization: ARM Ltd
In-Reply-To: <1419776431-26217-1-git-send-email-christoffer.dall@linaro.org>
References: <1419776431-26217-1-git-send-email-christoffer.dall@linaro.org>
Message-ID: <71346397bb3c0e654aa5b634328ae29c@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: christoffer.dall@linaro.org, daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, olof@lixom.net, yingjoe.chen@mediatek.com, sonnyrao@chromium.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-28 14:20, Christoffer Dall wrote:
> Commit 0b46b8a718c6e ("clocksource: arch_timer: Fix code to...") 
> fixes
> timer issues with certain ARMv7 platforms, but unfortunately breaks
> arm64 platforms with hyp mode (EL2) enabled.
>
> The commit only sets arch_timer_use_virtual to false under 
> CONFIG_ARM,
> but forgets that the config variable is also set in other code paths
> (actually, right underneath the check in the patch) with detrimental
> consequences as we've now introduced a direct early call to BUG() on
> practically all arm64 platforms.
>
> One could argue that this code could be refactored to use different
> variables for checking which *timer* to use and which *counter* to 
> use,
> which seems to be the desired difference between ARM and arm64 in 
> this
> case, but this approach fixes an urgent issue for now.
>
> Cc: Sonny Rao <sonnyrao@chromium.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> ---
> This was apparently already discovered by Yingjoe Chen in this thread
> https://lkml.org/lkml/2014/11/24/41 and Catalin recommended a similar
> fix.

I'm increasingly worried about the time it takes to get such critical
fixes into the tree (arm64 is *dead* without it).

What is holding this patch which, as far as I remember, has been posted
by Catalin almost three weeks ago?

Daniel?

         M.
-- 
Fast, cheap, reliable. Pick two.

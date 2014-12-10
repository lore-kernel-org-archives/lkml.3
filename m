Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaLJJTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:19:45 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41018 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752694AbaLJJTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:19:41 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>, Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Eddie Huang =?UTF-8?Q?=28=E9=BB=83=E6=99=BA=E5=82=91=29?= 
	<eddie.huang@mediatek.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
In-Reply-To: <20141209165807.GJ31129@e104818-lin.cambridge.arm.com>
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org>
	 <1417776064.14380.17.camel@mtksdaap41>
	 <20141208162140.GN16185@e104818-lin.cambridge.arm.com>
	 <1418106718.32622.31.camel@mtksdaap41>
	 <20141209165807.GJ31129@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Dec 2014 17:19:26 +0800
Message-ID: <1418203166.21309.3.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 16:58 +0000, Catalin Marinas wrote:
<...>
> You mix timer and counter terms here. Anyway, of we use physical timer,
> you could argue that it makes sense to use the corresponding physical
> counter (CNTPCT). However, on arm64 we only expose CNTVCT to user VDSO
> and we want to use the same in the kernel. When booting at EL2, CNTVCT
> == CNTPCT because we control CNTVOFF, that's unless we have some broken
> firmware that does not restore CNTVOFF correctly. That's what we want
> to spot early, hence the aim to always use the virtual counter (but not
> the timer, use use the physical timer as it makes it easier for KVM).
> 
> So the patch below, on top of linux-next, should solve the BUG():

Thanks for detail explanation and the patch. I tested it on my platform
and it did solve the issue. So,

Tested-by: Yingjoe Chen <yingjoe.chen@mediatek.com>

Joe.C



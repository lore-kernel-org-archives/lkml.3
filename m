Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaI2NMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:12:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35036 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaI2NMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:12:30 -0400
Message-ID: <54295ABA.1010806@codeaurora.org>
Date: Mon, 29 Sep 2014 09:12:26 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: olof@lixom.net, mark.rutland@arm.com, devicetree@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, galak@codeaurora.org, robh+dt@kernel.org,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] clocksource: arch_timer: Allow the device tree to
 specify the physical timer
References: <1410454801-14231-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1410454801-14231-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 09/11/2014 01:00 PM, Doug Anderson wrote:
> Some 32-bit (ARMv7) systems are architected like this:
> 
> * The firmware doesn't know and doesn't care about hypervisor mode and
>   we don't want to add the complexity of hypervisor there.
> 
> * The firmware isn't involved in SMP bringup or resume.
> 
> * The ARCH timer come up with an uninitialized offset between the
>   virtual and physical counters.  Each core gets a different random
>   offset.
> 
> * The device boots in "Secure SVC" mode.

I believe this can safely be detected by whether a write to CNTFRQ succeeds
(handling the UNDEF on failure). I've tested this approach in what I've
determined to be the 19 valid combinations of the following options.

* AArch64 EL3, AArch32 EL3, no EL3
* AArch64 EL2, AArch32 EL2, no EL2
* Start in SVC_N, SVC_S, HYP_N, MON_S

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

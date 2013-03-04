Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3CDEUC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:20:02 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60536 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434Ab3CDET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:19:59 -0500
Date: Mon, 4 Mar 2013 04:19:27 +0000
From: Will Deacon <will.deacon@arm.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] arm: l2x0: Leverage power saving features
Message-ID: <20130304041927.GA14686@mudshark.cambridge.arm.com>
References: <da92149b-159b-40e3-87b4-a0a448d1da8b@CO1EHSMHS031.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da92149b-159b-40e3-87b4-a0a448d1da8b@CO1EHSMHS031.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Soren,

On Fri, Mar 01, 2013 at 06:51:26PM +0000, Soren Brinkmann wrote:
> Enable the 'dynamic clock stop' and 'standby mode' features in the
> l2x0 disable path.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi,
> 
> we are currently implementing a suspend to RAM like low power mode for
> Zynq.
> The code for entering suspend looks like this:
> 	outer_disable();                                                 
>         cpu_suspend(0, zynq_pm_suspend);                                 
>         outer_resume();
> 
> In our low power guidelines we mention the pl310's standby and clock stop
> feature and that they should be enabled for low power modes. The question
> arising here now is: Does the outer_disable() make these features redundant,
> or does it make sense to add it like shown in this patch?

The settings in the power control register are unrelated to CPU suspend
afaict. Instead, they are for semi-autonomous entry to non-destructive
low-power states (e.g. when the L2 is idle for n cycles, or all of the L1
masters have asserted WFI).

This raises the question of whether or not we should poke this register at
all (other than saving/restoring it across suspend, which *is* destructive).
I personally think that this stuff is better off being dealt with in
firmware and initialised there, which follows what we do for other registers
like this.

Will

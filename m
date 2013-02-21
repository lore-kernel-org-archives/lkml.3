Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3BUM0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 07:26:09 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15986 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3BUM0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 07:26:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 21 Feb 2013 04:25:00 -0800
Date: Thu, 21 Feb 2013 14:25:36 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
Message-ID: <20130221122536.GJ23234@tbergstrom-lnx.Nvidia.com>
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
 <1360868369-20093-2-git-send-email-hdoyu@nvidia.com>
 <511D45E0.1080105@wwwdotorg.org>
 <20130215092407.GO3073@tbergstrom-lnx.Nvidia.com>
 <511E6639.1090909@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <511E6639.1090909@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 05:45:45PM +0100, Stephen Warren wrote:

...

> > I would suggest removing this clock. It's not actually implemented in the CCF
> > and rather useless. If you would gate the CPU clock from the CPU by writing to
> > this register, how would you ungate it? :) Note that this would gate the clock
> > to all CPUs.
> 
> (Note that my comment was re: all clocks, not just that one clock)
> 
> Can't the PMC or flow-controller ungate the clock based on some event?

I don't think the flow-controller controls this gate. The usual way of
clockgating a core is to execute a WFI instruction. That will trigger
clockgating the core, unless the flow-controller has been programmed to do
something else. The flow-controller will ungate the clock when there is an
interrupt.

> Either way, that clock definition exists in HW, right? So I don't think
> there's actually any harm in including the definition in the binding
> even if we never implement/use it.

The clock definition seems to exist in HW yes, the corresponding resetbit
however is marked as 'reserved' in the Tegra114 documentation.

Cheers,

Peter.

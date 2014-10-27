Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaJ0Nvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:51:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45378 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393AbaJ0Nv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:51:27 -0400
Date: Mon, 27 Oct 2014 13:50:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
Message-ID: <20141027135035.GA2629@leverpostej>
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

[...]

>  dtb-$(CONFIG_ARCH_THUNDER) += thunder-88xx.dtb
>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> +dtb-$(CONFIG_ARCH_SEATTLE) += amd-seattle.dtb

This should move earlier in the list (to keep things organised
alphabetically).

[...]

> +	v2m_serial0: uart@1010000 {

Drop the "v2m_" prefix -- in other dts that refers to a Versatile
Express μATX motherboard (the V2M-P1), and this isn't a Versatile
Express.

Also, I believe the preferred node name is "serial" rather than "uart".

[...]

> +	chosen {
> +		linux,stdout-path = "console=ttyAMA0,115200 earlycon=pl011,0xe1010000";

The stdout-path property should just be a path to the UART node. It's
not a direct replacement for /chosen/bootargs.

This should be (assuming you fix up the label above):

	stdout-path = &serial0;

That will give us earlycon if "earlycon" (with no arguments) is provided
on the command line, and should set up that UART as the console. There's
no need for the "linux," prefix now either.

Unfortuantely, I believe that the UART rate will get changed when the
real PL011 driver registers, unless the rate is explicitly provided on
the command line. It might be worth looking into retaining the
configured rate somehow indepentent of bootargs (unless overriden).

Thanks,
Mark.

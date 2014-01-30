Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaA3Qyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:54:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:58535 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaA3Qyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:54:49 -0500
Message-ID: <52EA83D6.9050506@codeaurora.org>
Date: Thu, 30 Jan 2014 11:54:46 -0500
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ian Campbell <ian.campbell@citrix.com>
CC: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: document "mach-virt" platform.
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
In-Reply-To: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On 01/30/2014 11:11 AM, Ian Campbell wrote:
> mach-virt has existed for a while but it is not written down what it actually
> consists of. Although it seems a bit unusual to document a binding for an
> entire platform since mach-virt is entirely virtual it is helpful to have
> something to refer to in the absence of a single concrete implementation.
> 
> I've done my best to capture the requirements based on the git log and my
> memory/understanding.
> 
> While here remove the xenvm dts example, the Xen tools will now build a
> suitable mach-virt compatible dts when launching the guest.

[...]

> +++ b/Documentation/devicetree/bindings/arm/mach-virt.txt
> @@ -0,0 +1,32 @@
> +* Mach-virt "Dummy Virtual Machine" platform
> +
> +"mach-virt" is the smallest, dumbest platform possible, to be used as
> +a guest for Xen, KVM and other hypervisors.

The platform is also useful to, and used by, simulators like QEMU in TCG mode.

>                                              It has no
> +properties/functionality of its own and is driven entirely by device
> +tree.

I find this wording confusing. I read it as saying the platform has no
properties or functionality. Perhaps you could phrase it slightly differently,
such as having no properties or functionality beyond what's described in the
device tree.

> +This document defines the requirements for such a platform.
> +
> +* Required properties:
> +
> +- compatible: should be one of:
> +	"linux,dummy-virt"
> +	"xen,xenvm"
> +
> +In addition to the standard nodes (chosen, cpus, memory etc) the
> +platform is required to provide certain other basic functionality
> +which must be described in the device tree:
> +
> +    The platform must provide an ARM Generic Interrupt Controller
> +    (GIC), defined in Documentation/devicetree/bindings/arm/gic.txt.
> +
> +    The platform must provide ARM architected timer, defined in
> +    Documentation/devicetree/bindings/arm/arch_timer.txt.
> +
> +    If the platform is SMP then it must provide the Power State
> +    Coordination Interface (PSCI) described in
> +    Documentation/devicetree/bindings/arm/psci.txt.
> +
> +The platform may also provide hypervisor specific functionality
> +(e.g. PV I/O), if it does so then this functionality must be
> +discoverable (directly or indirectly) via device tree.

I think it would be informative to provide pointers here to commonly used
paravirtualized devices, especially VirtIO PCI/MMIO.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.

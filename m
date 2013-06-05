Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3FEOHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:07:08 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:43918 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3FEOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:07:06 -0400
Date: Wed, 5 Jun 2013 10:07:03 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v2 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
In-Reply-To: <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
Message-ID: <alpine.LFD.2.03.1306050956081.1200@syhkavp.arg>
References: <1370432767-6620-1-git-send-email-lorenzo.pieralisi@arm.com> <1370432767-6620-3-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Lorenzo Pieralisi wrote:

> The TC2 versatile express core tile integrates a logic block that provides the
> interface between the dual cluster test-chip and the M3 microcontroller that
> carries out power management. The logic block, called Serial Power Controller
> (SPC), contains several memory mapped registers to control among other things
> low-power states, operating points and reset control.
> 
> This patch provides a driver that enables run-time control of features
> implemented by the SPC control logic.
> 
> The driver also provides a bridge interface through the vexpress config
> infrastructure. Operations allowing to read/write operating points are
> made to go via the same interface as configuration transactions so that
> all requests to M3 are serialized.
> 
> Device tree bindings documentation for the SPC component is provided with
> the patchset.
> 

[...]

> +/*
> + * Versatile Express Serial Power Controller (SPC) support
> + *
> + * Copyright (C) 2013 ARM Ltd.
> + *
> + * Author(s): Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> + *            Achin Gupta           <achin.gupta@arm.com>
> + *            Lorenzo Pieralisi     <lorenzo.pieralisi@arm.com>

I imagine "author(s)" can be written as "authors" without a doubt.  :-)

> +EXPORT_SYMBOL_GPL(vexpress_spc_write_resume_reg);
> +EXPORT_SYMBOL_GPL(vexpress_spc_set_global_wakeup_intr);
> +EXPORT_SYMBOL_GPL(vexpress_spc_set_cpu_wakeup_irq);
> +EXPORT_SYMBOL_GPL(vexpress_spc_powerdown_enable);

I don't think anything that could possibly be made into modules should 
ever have a need for those particular calls.  So I'd suggest not 
exporting them.

Other than that, you may add...

Reviewed-by: Nicolas Pitre <nico@linaro.org>


Nicolas

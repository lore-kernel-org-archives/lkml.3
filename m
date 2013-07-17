Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3GQD0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 23:26:54 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:52879 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3GQD0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 23:26:52 -0400
Date: Tue, 16 Jul 2013 23:26:49 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
In-Reply-To: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
Message-ID: <alpine.LFD.2.03.1307162323530.14924@syhkavp.arg>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013, Lorenzo Pieralisi wrote:

> Hello,
> 
> version v5 of VExpress SPC driver, please read on the changelog for major
> changes and explanations.
> 
> The probing scheme is unchanged, since after trying the early platform
> devices approach it appeared that the end result was no better than the
> current one. The only clean solution relies either on changing how
> secondaries are brought up in the kernel (later than now) or enable
> early platform device registration through DT. Please check this
> thread for the related discussion:
> 
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/036542.html
> 
> The interface was adapted to regmap and again reverted to old driver for
> the following reasons:
> 
> - Power down registers locking is hairy and requires arch spinlocks in
>   the MCPM back end to work properly, normal spinlocks cannot be used
> - Regmap adds unnecessary code to manage SPC since it is just a bunch of
>   registers used to control power management flags, the overhead is just
>   not worth it (talking about power down registers, not the vexpress config
>   interface)
> - The locking scheme behind regmap requires all registers in the map
>   to be protected with the same lock, which is not exactly what we want
>   here
> - Given the reasons above, adding a regmap interface buys us nothing from
>   a driver readability and maintainability perspective (again just talking
>   about the power interface, a few registers) because for the SPC it would
>   simply not be used
> 
> /drivers/mfd is probably not the right place for this code as it stands (but
> probably will be when the entire driver, with DVFS and config interface, is
> complete).
> 
> Thank you for the review in advance,
> Lorenzo

I've integrated this patch in my MCPM backend for TC2 patch series.

ACKs from concerned/interested people would be appreciated so I could 
send this for ARM-SOC inclusion right away.


Nicolas

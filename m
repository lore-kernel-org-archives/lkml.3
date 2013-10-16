Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab3JPNVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:21:15 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52098 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760544Ab3JPNVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:21:15 -0400
Date: Wed, 16 Oct 2013 14:20:43 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Neil Zhang <zhangwm@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yu Tang <ytang5@marvell.com>, Zhou Zhu <zzhu3@marvell.com>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [Question] Ask for arm arch timer
Message-ID: <20131016132042.GC4196@arm.com>
References: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF280@SC-VEXCH4.marvell.com>
 <525E8DAD.60801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525E8DAD.60801@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 01:59:25PM +0100, Rob Herring wrote:
> On 10/16/2013 07:39 AM, Neil Zhang wrote:
> > I saw your following patch called clocksource_of_init() directly in
> > time_init() for arm64.
> > My question is that what should we do if there are some Soc special
> > work need to be done before arch timer can be used?
> > Thanks in advance.
> 
> If the timer itself is different, then you should have a different DT
> compatible string which you can use to trigger additional initialization.
> 
> Integration level initialization like enabling clocks would need
> something different as no machine descriptors exist for arm64.
> 
> Another option would be do the setup in secure world or the bootloader.

The generic timer should indeed be initialised in the firmware
(bootloader may not be suitable if initialisation needs to happen on
each CPU). Linux doesn't need to do other things than reading the
frequency, programming the interrupts, counters (but definitely not
SoC-specific initialisation).

> Can you be more specific what initialization is needed.

I'm interested in this as well.

-- 
Catalin

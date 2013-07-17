Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3GQMdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:33:08 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34704 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab3GQMdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:33:06 -0400
Date: Wed, 17 Jul 2013 08:33:02 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
In-Reply-To: <1374052705.3146.86.camel@hornet>
Message-ID: <alpine.LFD.2.03.1307170825240.14924@syhkavp.arg>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com> <1374052705.3146.86.camel@hornet>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Pawel Moll wrote:

> On Tue, 2013-07-16 at 17:05 +0100, Lorenzo Pieralisi wrote:
> > /drivers/mfd is probably not the right place for this code as it stands (but
> > probably will be when the entire driver, with DVFS and config interface, is
> > complete).
> 
> Not that it really matters now, but my vexpress-sysreg rework will -
> most likely - leave only skeleton in the MFD (registering mfd_cells) and
> other stuff is going to be spread all around. Then I'm planning to move
> the remaining of the vexpress-specific initialization to
> drivers/platform/arm/vexpress.c, so maybe sticking vexpress-spc.c to
> this (non-existing yet) directory would be the right thing to do?

I don't like this idea.  We worked hard to shrink platform specific 
directories such as arch/arm/mach-*/ as much as possible.  Simply moving 
stuff to drivers/platform/arm/* doesn't make the situation any much 
better.

If this is really miscelaneous code that really doesn't fit 
anywhere else, it should rather go into drivers/misc/ as a last resort.


Nicolas

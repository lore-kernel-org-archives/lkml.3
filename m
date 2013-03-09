Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3CITse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:48:34 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63754 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab3CITsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:48:32 -0500
Message-ID: <1362858510.3137.31.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 09 Mar 2013 20:48:30 +0100
In-Reply-To: <20130309000157.GE30923@n2100.arm.linux.org.uk>
References: <1362738596.5994.48.camel@x61.thuisdomein>
	 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
	 <20130308163507.GC26093@atomide.com>
	 <1362763232.5994.75.camel@x61.thuisdomein>
	 <20130308175539.GG26093@atomide.com>
	 <1362765764.5994.87.camel@x61.thuisdomein>
	 <20130309000157.GE30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2013 19:48:31.0130 (UTC) FILETIME=[139827A0:01CE1CFF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-09 at 00:01 +0000, Russell King - ARM Linux wrote:
> It's actually quite clever.  There's two levels to it.
> 
> The first is that CONFIG_MACH_xxx result in their machine_is_xxx() macros
> being defined to constant zero if the CONFIG option is not enabled.  That
> allows the compiler to throw away code for disabled platforms because
> the expression is always false.
> 
> Otherwise, they end up as (machine_arch_type == MACH_TYPE_xxx).
> 
> The second is the magic which happens when two CONFIG_MACH_xxx are
> selected.  If only one is selected, then machine_arch_type is defined
> to the appropriate MACH_TYPE_xxx.  This means that the above expression
> becomes constant-true, and the conditional is eliminated.
> 
> If more than one is selected, then machine_arch_type is defined to a
> variable which is appropriately set to one of the MACH_TYPE_xxx values.

At boot?

> So, the result is that:
> - de-selected platforms have their if (machine_is_xxx()) { } optimised
>   out of the kernel.
> - for a kernel built targetting one platform, all the
>   if (machine_is_xxx()) tests are optimised away, leaving only the
>   relevant code behind.
> - otherwise, we get the _appropriate_ conditional code for the
>   configuration generated.

Thanks for clarifying this. Quite clever indeed. 

> However, going back to that MACH_NOKIA_RM696.  If there exists only a
> select of this symbol and no "config MACH_NOKIA_RM696" entry, then the
> symbol will never be generated in the output .config file.
> 
>[...]
> 
> My conclusion is... it's a mess.

That mess can only be fully cleaned up if the code for the RM-696 that
now is maintained in some unknown to me repository gets merged into
mainline, can't it?

In the meantime, how do you prefer I solve the (trivial) issue of an
useless select for MACH_NOKIA_RM696? Drop that select or add an (equally
useless) config entry for MACH_NOKIA_RM696? Or should I try to ignore it
for the time being?


Paul Bolle


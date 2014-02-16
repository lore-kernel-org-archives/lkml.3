Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaBPUfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:35:04 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52948 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753320AbaBPUfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:35:03 -0500
Message-ID: <1392582900.28866.85.camel@x220>
Subject: Re: [PATCH] arm: imx: remove MACH_MXLADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Russell King <linux@arm.linux.org.uk>, Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Date: Sun, 16 Feb 2014 21:35:00 +0100
In-Reply-To: <1392578464.996901773@f49.i.mail.ru>
References: <1392573811.28866.22.camel@x220>
	 <1392577615.265469392@f161.i.mail.ru> <1392577965.28866.37.camel@x220>
	 <1392578464.996901773@f49.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Feb 2014 20:35:00.0799 (UTC) FILETIME=[9077DCF0:01CF2B56]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 23:21 +0400, Alexander Shiyan wrote:
> Воскресенье, 16 февраля 2014, 20:12 +01:00 от Paul Bolle <pebolle@tiscali.nl>:
> > On Sun, 2014-02-16 at 23:06 +0400, Alexander Shiyan wrote:
> > > Kconfig selects MACH_MXLADS, this enables machine_arch_type
> > > from include/generated/mach-types.h which used for machine_is_xx() macro,
> > > so if multiple boards is defined in the kernel, this cause to incorrect
> > matching.
> > 
> > But, as I stated in the commit explanation, there are no users of
> > machine_is_mxlads().
> 
> If you have MXLADS and FOO boards support in the kernel (for example)
> and you want to start MXLADS version, your machine_is_FOO() will be positive,
> since machine_arch_type will be constant value FOO in this case.

I think it might be helpful - for people trying to understand this
thread - to add a quote from https://lkml.org/lkml/2013/3/8/473 :
    So, the result is that:
    - de-selected platforms have their if (machine_is_xxx()) { } optimised
      out of the kernel.
    - for a kernel built targetting one platform, all the
      if (machine_is_xxx()) tests are optimised away, leaving only the
      relevant code behind.
    - otherwise, we get the _appropriate_ conditional code for the
      configuration generated.

Back to the issue at hand: without my patch ARCH_MX1ADS selects
MACH_MXLADS. So it seems in this case people will have to select
ARCH_MX1ADS besides selecting FOO. Wouldn't that solve this problem?
Note that the MACH_MXLADS is now basically meant to be selected by
ARCH_MX1ADS and not set directly anyway.


Paul Bolle


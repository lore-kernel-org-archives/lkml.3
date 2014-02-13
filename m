Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaBMSVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:21:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44668 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaBMSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:21:48 -0500
Date: Thu, 13 Feb 2014 18:21:06 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
Message-ID: <20140213182105.GN13576@mudshark.cambridge.arm.com>
References: <52FD08D1.3030405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FD08D1.3030405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,

Thanks for bisecting this.

On Thu, Feb 13, 2014 at 06:02:57PM +0000, Ivaylo Dimitrov wrote:
> Since next-21012014 I started to receive "Received disconnect from 
> x.x.x.x: 2: Bad packet length 3149594624" errors when trying to 
> establish ssh session over wifi to my N900, running Maemo 5. I bisected 
> and it turned out that commit dce5c9e35bc4085bd33eccdb8c9ec5a643507a14 
> "ARM: 7928/1: kconfig: select HAVE_EFFICIENT_UNALIGNED_ACCESS for CPUv6+ 
> && MMU" is the first bad. There is nothing related in either dmesg or 
> syslog on the device. Reverting that commit on 3.14-rc1 make those 
> errors disappear.

That's certainly unexpected. The n900 has (iirc) a Cortex-A8, which as an
ARMv7 core, can perform unaligned accesses to normal, cacheable memory in
hardware.

Can you provide your .config and/or any information about your network chip
please? There's a chance that the driver is doing something odd.

Cheers,

Will

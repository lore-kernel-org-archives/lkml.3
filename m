Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbaDWPpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:45:41 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40444 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaDWPpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:45:38 -0400
Date: Wed, 23 Apr 2014 08:45:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
Message-ID: <20140423154533.GA15644@roeck-us.net>
References: <20140422172356.GA15672@roeck-us.net>
 <53575074.6010602@monstr.eu>
 <5357C246.7050604@roeck-us.net>
 <5357CA6B.1070101@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5357CA6B.1070101@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:12:59PM +0200, Michal Simek wrote:
> On 04/23/2014 03:38 PM, Guenter Roeck wrote:
> > On 04/22/2014 10:32 PM, Michal Simek wrote:
> >> Hi Guenter,
> >>
> >>
> >> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
> >>> Hi all,
> >>>
> >>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qemu,
> >>> I get the following hangup. This used to work with earlier kernels
> >>> with the same configuration.
> >>>
> >>> Is this a known problem, or is something wrong with my configuration
> >>> or with my qemu command line ?
> >>
> >> Is this BE/LE version? Which qemu do you use?
> > 
> > BE.
> > 
> > file vmlinux:
> > 
> > vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically linked, BuildID[sha1]=5e1872c08df2956eddaed6fc1f6528a8540375b7, not stripped
> > 
> > qemu-system-microblaze --version:
> > 
> > QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellard
> > 
> > gcc --version:
> > 
> > microblaze-linux-gcc (GCC) 4.8.0
> > Copyright (C) 2013 Free Software Foundation, Inc.
> > This is free software; see the source for copying conditions.  There is NO
> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > 
> >> There is endian autodetection in timer and intc driver
> >> which can caused this problem.
> >>
> > Is this new code ? I didn't see the problem in 3.13 (same compile options,
> > same configuration, same compiler, same qemu version).
> 
> yes it was added to 3.15-rc1.
> 
> Try to rever this one
> a66a626 microblaze: Use asm-generic/io.h
> 
> but the problem is probably here because you are not getting proper
> reaction from qemu model.
> a1715bb microblaze: Make timer driver endian aware
> 1aa1243 microblaze: Make intc driver endian aware
> 
> I have tested it on the latest petalinux qemu and there shouldn't be
> any problem.
> 
Hi Michal,

qemu 2.0.0 still has the problem. Bisect points to

commit a66a626538af65cbfc611e2b2fce500ed3f24518
Author: Michal Simek <michal.simek@xilinx.com>
Date:   Thu Feb 7 15:12:24 2013 +0100

    microblaze: Use asm-generic/io.h

as the culprit, so you were right on the money. Reverting this commit
fixes the problem.

Assuming this is in fact a problem with qemu, can you point me to a set
of qemu patches necessary to fix it ? Also, do you know if there are plans
to send the patches upstream ? I don't find anything related in the qemu
repository (though of course I may have missed it).

Thanks,
Guenter

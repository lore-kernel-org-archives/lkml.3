Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaEWVhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:37:09 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44819 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEWVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:37:08 -0400
Date: Fri, 23 May 2014 23:37:01 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
Message-ID: <20140523213701.GD23153@alberich>
References: <1400602574.4912.43.camel@x220>
 <20140522132645.GC10287@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140522132645.GC10287@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 03:26:45PM +0200, Ralf Baechle wrote:
> On Tue, May 20, 2014 at 06:16:14PM +0200, Paul Bolle wrote:
> 
> > Three checks for CONFIG_CAVIUM_GDB were added in v2.6.29. But the
> > Kconfig symbol CAVIUM_GDB was never added to the tree. Remove these
> > checks.
> > 
> > Also remove the last reference to octeon_get_boot_debug_flag(). There is
> > no definition of that function anyway.
> > 
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> 
> Queued for 3.16.  Thanks Paul & Andreas!
> 
> > A follow up might be to remove plat_smp_ops.cpus_done. All these
> > callbacks are now (basically) nops.
> 
> I'll think about it.  The hook is no useful if unused then again now and
> then ordering issues in SMP startup of secondary CPUs are showing up and
> it may be useful to solve those.  Maybe something like
> 
> void __init smp_cpus_done(unsigned int max_cpus)
> {
> - 	mp_ops->cpus_done();
> + 	if (cpus_done)
> + 		mp_ops->cpus_done();
> }
> 
> which would make a NULL cpus_done function pointer safe and allow empty definitions
> to be removed.

I'd prefer this solution over complete removal of the hook.


Andreas

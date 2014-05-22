Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaEVN04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:26:56 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37220 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEVN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:26:55 -0400
Date: Thu, 22 May 2014 15:26:45 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: cavium-octeon: remove checks for CONFIG_CAVIUM_GDB
Message-ID: <20140522132645.GC10287@linux-mips.org>
References: <1400602574.4912.43.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400602574.4912.43.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 06:16:14PM +0200, Paul Bolle wrote:

> Three checks for CONFIG_CAVIUM_GDB were added in v2.6.29. But the
> Kconfig symbol CAVIUM_GDB was never added to the tree. Remove these
> checks.
> 
> Also remove the last reference to octeon_get_boot_debug_flag(). There is
> no definition of that function anyway.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Queued for 3.16.  Thanks Paul & Andreas!

> A follow up might be to remove plat_smp_ops.cpus_done. All these
> callbacks are now (basically) nops.

I'll think about it.  The hook is no useful if unused then again now and
then ordering issues in SMP startup of secondary CPUs are showing up and
it may be useful to solve those.  Maybe something like

void __init smp_cpus_done(unsigned int max_cpus)
{
- 	mp_ops->cpus_done();
+ 	if (cpus_done)
+ 		mp_ops->cpus_done();
}

which would make a NULL cpus_done function pointer safe and allow empty definitions
to be removed.

  Ralf

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaFZOBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 10:01:21 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43783 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751557AbaFZOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 10:01:20 -0400
Date: Thu, 26 Jun 2014 15:01:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140626140115.GQ32514@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 01:55:05PM +0000, Mattis Lorentzon wrote:
> Hello kernel people,

You may wish to also copy linux-arm-kernel@lists.infradead.org, which is
where ARM kernel people are.

> I have a similar issue with v3.16-rc2 as previously reported by Waldemar Brodkorb for v3.15-rc4.
> https://lkml.org/lkml/2014/5/9/330

This URL returns no useful information.  I find that lkml.org is broken
more times than not in recent years.  Please use a different archive
site when referring to posts, thanks.

> We are running a benchmark application, sometimes using perf, with heavy
> traffic over NFS.

I have had two iMX6 platforms running root-NFS for about the last six to
nine months with various workloads, and have never seen this oops.
Unfortunately, the description above gives very little information for
what the mechanism to trigger this bug may be.  For example, if I wanted
to reproduce it, what would I need to do?

> The error is sporadic and it seems to occur more frequently when using perf.

So it occurs when not using perf?

> Linux imx6-test0 3.16.0-rc2+ #1 SMP Wed Jun 25 15:04:16 CEST 2014 armv7l armv7l armv7l GNU/Linux
> 
> Any help is greatly appreciated.
> 
> Best regards,
> Mattis Lorentzon
> 
> Unable to handle kernel paging request at virtual address ffffffff
> pgd = 9e338000
> [ffffffff] *pgd=2fffd821, *pte=00000000, *ppte=00000000
> Internal error: Oops: 17 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 146 Comm: stereo Not tainted 3.16.0-rc2+ #1
> task: 9e07a700 ti: 81c42000 task.ti: 81c42000
> PC is at find_get_entry+0x60/0xfc
> LR is at radix_tree_lookup_slot+0x1c/0x2c
> pc : [<800a34d8>]    lr : [<80290448>]    psr: a0000013
> sp : 81c43d98  ip : 00000000  fp : 81c43dcc
> r10: 00000001  r9 : 9e30e3c0  r8 : 000002a7
> r7 : 9f3758a0  r6 : 00000000  r5 : 00000001  r4 : 00000000
> r3 : 81c43d84  r2 : 00000000  r1 : 000002a7  r0 : ffffffff
...
> Code: e1a01008 eb07b3d6 e3500000 0a00001c (e5904000)

Right, so radix_tree_lookup_slot returned 0xffffffff.  I've no idea how
that happened, and I'm not about to try reading and trying to understand
that code.  However, as that is generic code, I find it unlikely that
the code is buggy.  So, I suspect something else must be going on here,
such as a compiler bug or memory corruption.

Your other oops dumps also show various other functions apparantly
returning 0xffffffff.  I can't believe that there's more than one bug
doing this, so I doubt the problem is in these functions.  Something
else must be going on.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

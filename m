Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab3JVRqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:46:21 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57227 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3JVRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:46:19 -0400
Date: Tue, 22 Oct 2013 20:46:12 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20131022174612.GC24448@blackmetal.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1306162346340.23595@math.ut.ee>
 <20130617053225.GA3073@blackmetal.musicnaut.iki.fi>
 <20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
 <20130803.134042.2228681844349448961.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803.134042.2228681844349448961.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Aug 03, 2013 at 01:40:42PM -0700, David Miller wrote:
> > On Mon, Jun 17, 2013 at 08:32:25AM +0300, Aaro Koskinen wrote:
> >> On Mon, Jun 17, 2013 at 12:06:00AM +0300, Meelis Roos wrote:
> >> > Got this in 3.10-rc6 whil testing debian unstable upgrade with aptitude. 
> >> > 3.10-rc5 did not exhibit this (nor any other kernel recently tried, 
> >> > including most -rc's). Does not seem to be reproducible.
> >> 
> >> I get this regularly on Ultrasparc during long compilations. It's been
> >> there with all recent kernels (probably at least since 3.8). Latest I
> >> saw with 3.10-rc5.
> > 
> > Two examples:
> 
> Thanks for the reports, I'm actively looking into this.

Got this again with 3.12-rc5 while doing GCC 4.8.2 bootstrap (during
make check phase):

[83998.025998] ------------[ cut here ]------------
[83998.080312] WARNING: CPU: 0 PID: 3983 at /home/aaro/los/work/shared/linux-v3.12-rc5/mm/mmap.c:2729 exit_mmap+0x138/0x160()
[83998.212541] Modules linked in:
[83998.248987] CPU: 0 PID: 3983 Comm: expect Not tainted 3.12.0-rc5-ultra-los.git-d7b26d7-dirty #1
[83998.353171] Call Trace:
[83998.382310]  [00000000004b79d8] exit_mmap+0x138/0x160
[83998.442723]  [00000000004503cc] mmput+0x2c/0xc0
[83998.496885]  [00000000004cf338] flush_old_exec+0x418/0x520
[83998.562508]  [000000000051294c] load_elf_binary+0x20c/0x1660
[83998.630194]  [00000000004ce9f8] search_binary_handler+0x78/0x200
[83998.702061]  [00000000004cfc1c] do_execve_common.isra.48+0x3dc/0x500
[83998.778105]  [00000000004cffcc] compat_sys_execve+0x2c/0x60
[83998.844758]  [0000000000406074] linux_sparc_syscall32+0x34/0x40
[83998.915565] ---[ end trace 1f66da8de6eddeb8 ]---
[83998.970773] BUG: Bad rss-counter state mm:fffff80019c4c000 idx:1 val:512
[85190.371621] ld[17707]: segfault at 58 ip 00000000f7d0d164 (rpc 00000000f7d0cf90) sp 00000000ffc36a20 error 30001 in libbfd-2.23.2.so[f7cc8000+ba000]

The box didn't die yet... Let's hope it will let GCC testsuite to finish.

A.

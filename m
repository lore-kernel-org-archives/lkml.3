Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3FQF6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:58:48 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:47039 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3FQF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:58:47 -0400
Date: Mon, 17 Jun 2013 08:58:39 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Meelis Roos <mroos@linux.ee>
Cc: sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20130617055839.GB3073@blackmetal.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1306162346340.23595@math.ut.ee>
 <20130617053225.GA3073@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617053225.GA3073@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 17, 2013 at 08:32:25AM +0300, Aaro Koskinen wrote:
> On Mon, Jun 17, 2013 at 12:06:00AM +0300, Meelis Roos wrote:
> > Got this in 3.10-rc6 whil testing debian unstable upgrade with aptitude. 
> > 3.10-rc5 did not exhibit this (nor any other kernel recently tried, 
> > including most -rc's). Does not seem to be reproducible.
> 
> I get this regularly on Ultrasparc during long compilations. It's been
> there with all recent kernels (probably at least since 3.8). Latest I
> saw with 3.10-rc5.

Two examples:

[  417.006586] ------------[ cut here ]------------
[  417.065813] WARNING: at /home/aaro/los/work/shared/linux-v3.10-rc5/mm/mmap.c:2757 exit_mmap+0x134/0x160()
[  417.189209] Modules linked in:
[  417.229203] CPU: 0 PID: 1787 Comm: ld Not tainted 3.10.0-rc5-ultra #1
[  417.310031] Call Trace:
[  417.342875]  [00000000004b5ef4] exit_mmap+0x134/0x160
[  417.406941]  [000000000044ef40] mmput+0x40/0xe0
[  417.464591]  [0000000000454b38] do_exit+0x1b8/0x800
[  417.526429]  [0000000000455d6c] do_group_exit+0x2c/0xa0
[  417.592383]  [0000000000455df4] SyS_exit_group+0x14/0x20
[  417.659257]  [0000000000406074] linux_sparc_syscall32+0x34/0x40
[  417.733400] ---[ end trace b92a93fbf6d0204a ]---
[  417.791913] BUG: Bad rss-counter state mm:fffff8001ebbb740 idx:1 val:1

[ 1674.164634] ------------[ cut here ]------------
[ 1674.218933] WARNING: at /home/aaro/los/work/shared/linux-v3.10-rc5/mm/mmap.c:2757 exit_mmap+0x134/0x160()
[ 1674.333505] Modules linked in:
[ 1674.369872] CPU: 0 PID: 26306 Comm: date Not tainted 3.10.0-rc5-ultra #1
[ 1674.450075] Call Trace:
[ 1674.479245]  [00000000004b5ef4] exit_mmap+0x134/0x160
[ 1674.539661]  [000000000044ef40] mmput+0x40/0xe0
[ 1674.593827]  [0000000000454b38] do_exit+0x1b8/0x800
[ 1674.652140]  [0000000000455d6c] do_group_exit+0x2c/0xa0
[ 1674.714630]  [0000000000455df4] SyS_exit_group+0x14/0x20
[ 1674.778172]  [0000000000406074] linux_sparc_syscall32+0x34/0x40
[ 1674.848993] ---[ end trace 77928f0ca6684101 ]---
[ 1674.904199] BUG: Bad rss-counter state mm:fffff8000f0c9d40 idx:0 val:1

A.

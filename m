Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab3BYPcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:32:35 -0500
Received: from mail.tpi.com ([70.99.223.143]:4622 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab3BYPcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:32:33 -0500
Message-ID: <512B8407.2090807@canonical.com>
Date: Mon, 25 Feb 2013 08:32:23 -0700
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com>
In-Reply-To: <512B7D10.4060304@tpi.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 08:02 AM, Tim Gardner wrote:
> Is this an expected warning ? I'll boot a vanilla kernel just to be sure.
> 
> rebased against ab7826595e9ec51a51f622c5fc91e2f59440481a in Linus' repo:
> 

Same with a vanilla kernel, so it doesn't appear that any Ubuntu cruft
is having an impact:

[    0.170435] ------------[ cut here ]------------
[    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
topology_sane.isra.2+0x71/0x84()
[    0.170452] Hardware name: S2600CP
[    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
node! [node: 1 != 0]. Ignoring dependency.
[    0.156000] smpboot: Booting Node   1, Processors  #1
[    0.170455] Modules linked in:
[    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
[    0.170461] Call Trace:
[    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
[    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
[    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
[    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
[    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
[    0.170502] ---[ end trace 09222f596307ca1d ]---

rtg
-- 
Tim Gardner tim.gardner@canonical.com

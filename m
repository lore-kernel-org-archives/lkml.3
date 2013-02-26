Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3BZMgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:36:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:48178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3BZMgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:36:38 -0500
Date: Tue, 26 Feb 2013 13:36:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Regression introduced with 14e568e78f6f80ca1e27256641ddf524c7dbdc51
 (stop_machine: Use smpboot threads)
In-Reply-To: <20130223011800.GA2465@phenom.dumpdata.com>
Message-ID: <alpine.LFD.2.02.1302261320120.22263@ionos>
References: <20130223011800.GA2465@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Konrad Rzeszutek Wilk wrote:
> 
> I don't know if this is b/c the Xen code is missing something or
> expects something that never happend. I hadn't looked at your
> patch in any detail (was going to do that on Monday).
> 
> Either way, if I boot a HVM guest with PV extensions (aka PVHVM)
> this is I what get:
> [    0.133081] cpu 1 spinlock event irq 71
> [    0.134049] smpboot: Booting Node   0, Processors  #1[    0.008000] installing Xen timer for CPU 1
> [    0.205154] Brought up 2 CPUs
> [    0.205156] smpboot: Total of 2 processors activated (16021.74 BogoMIPS)
> 
> [   28.134000] BUG: soft lockup - CPU#0 stuck for 23s! [migration/0:8]
> [   28.134000] Modules linked in:
> [   28.134000] CPU 0 
> [   28.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
> [   28.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0

So the migration thread loops in stop_machine_cpu_stop(). Now the
interesting question is what work was scheduled for that cpu.

The main difference between the old code and the new one, is that the
thread is created earlier and not detroyed on cpu offline.

Could you add some instrumentation, so we can see what kind of cpu
stop work is scheduled and from where?

Thanks,

	tglx

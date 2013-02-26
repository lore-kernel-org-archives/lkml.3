Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3BZNHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:07:09 -0500
Received: from [84.200.39.61] ([84.200.39.61]:41911 "EHLO smtp.eikelenboom.it"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab3BZNHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:07:08 -0500
Date: Tue, 26 Feb 2013 14:07:02 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <894977724.20130226140702@eikelenboom.it>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Regression introduced with 14e568e78f6f80ca1e27256641ddf524c7dbdc51 (stop_machine: Use smpboot threads)
In-Reply-To: <alpine.LFD.2.02.1302261320120.22263@ionos>
References: <20130223011800.GA2465@phenom.dumpdata.com> <alpine.LFD.2.02.1302261320120.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tuesday, February 26, 2013, 1:36:36 PM, you wrote:

> On Fri, 22 Feb 2013, Konrad Rzeszutek Wilk wrote:
>> 
>> I don't know if this is b/c the Xen code is missing something or
>> expects something that never happend. I hadn't looked at your
>> patch in any detail (was going to do that on Monday).
>> 
>> Either way, if I boot a HVM guest with PV extensions (aka PVHVM)

Hmm i'm seeing this booting on baremetal as well.
(see http://lkml.indiana.edu/hypermail/linux/kernel/1302.3/00836.html)

>> this is I what get:
>> [    0.133081] cpu 1 spinlock event irq 71
>> [    0.134049] smpboot: Booting Node   0, Processors  #1[    0.008000] installing Xen timer for CPU 1
>> [    0.205154] Brought up 2 CPUs
>> [    0.205156] smpboot: Total of 2 processors activated (16021.74 BogoMIPS)
>> 
>> [   28.134000] BUG: soft lockup - CPU#0 stuck for 23s! [migration/0:8]
>> [   28.134000] Modules linked in:
>> [   28.134000] CPU 0 
>> [   28.134000] Pid: 8, comm: migration/0 Tainted: G        W    3.8.0upstream-06472-g6661875-dirty #1 Xen HVM domU
>> [   28.134000] RIP: 0010:[<ffffffff8110711b>]  [<ffffffff8110711b>] stop_machine_cpu_stop+0x7b/0xf0

> So the migration thread loops in stop_machine_cpu_stop(). Now the
> interesting question is what work was scheduled for that cpu.

> The main difference between the old code and the new one, is that the
> thread is created earlier and not detroyed on cpu offline.

> Could you add some instrumentation, so we can see what kind of cpu
> stop work is scheduled and from where?

> Thanks,

>         tglx




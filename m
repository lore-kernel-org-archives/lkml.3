Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbaBUNFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:05:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:38676 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbaBUNFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:05:50 -0500
Date: Fri, 21 Feb 2014 14:05:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>
Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq()
 wait-forever
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01C28A3B@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.02.1402211405280.21251@ionos.tec.linutronix.de>
References: <y> <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com> <alpine.DEB.2.02.1402100951290.21991@ionos.tec.linutronix.de> <27240C0AC20F114CBF8149A2696CBE4A01C269E8@SHSMSX101.ccr.corp.intel.com> <alpine.DEB.2.02.1402201218310.4468@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C27CF7@SHSMSX101.ccr.corp.intel.com> <alpine.DEB.2.02.1402211006130.4468@ionos.tec.linutronix.de> <27240C0AC20F114CBF8149A2696CBE4A01C287C7@SHSMSX101.ccr.corp.intel.com> <alpine.DEB.2.02.1402211209500.21251@ionos.tec.linutronix.de>
 <27240C0AC20F114CBF8149A2696CBE4A01C2886B@SHSMSX101.ccr.corp.intel.com> <alpine.DEB.2.02.1402211230100.21251@ionos.tec.linutronix.de> <27240C0AC20F114CBF8149A2696CBE4A01C28A3B@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Liu, Chuansheng wrote:
> > -----Original Message-----
> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Sent: Friday, February 21, 2014 7:53 PM
> > To: Liu, Chuansheng
> > Cc: linux-kernel@vger.kernel.org; Wang, Xiaoming
> > Subject: RE: [PATCH 1/2] genirq: Fix the possible synchronize_irq() wait-forever
> > 
> > On Fri, 21 Feb 2014, Liu, Chuansheng wrote:
> > > > > > I think you have a point there, but not on x86 wherre the atomic_dec
> > > > > > and the spinlock on the queueing side are full barriers. For non-x86
> > > > > > there is definitely a potential issue.
> > > > > >
> > > > > But even on X86, spin_unlock has no full barrier, the following scenario:
> > > > > CPU0                   CPU1
> > > > > spin_lock
> > > > >                        atomic_dec_and_test
> > > > > insert into queue
> > > > > spin_unlock
> > > > >                        checking waitqueue_active
> > > >
> > > > But CPU0 sees the 0, right?
> > > Not be clear here:)
> > > The atomic_read has no barrier.
> > >
> > > Found commit 6cb2a21049b89 has one similar smp_mb() calling before
> > > waitqueue_active() on one X86 CPU.
> > 
> > Indeed, you are completely right. Great detective work!
> Thanks your encouraging.
> 
> > 
> > I'm inclined to remove the waitqueue_active() alltogether. It's
> > creating more headache than it's worth.
> If I am understanding well, removing the checking of waitqueue_active(),
> and call wakeup() directly which will check list with spinlock protection.

Correct.
 
> If so, I can prepare one patch for it:)

Appreciated.

	tglx

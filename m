Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaBGHMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:12:03 -0500
Received: from mail.precitec.de ([85.115.17.50]:29519 "EHLO mail.precitec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaBGHMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:12:01 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Feb 2014 02:12:01 EST
X-CTCH-RefID: str=0001.0A0C0208.52F485DD.01B5,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
To: Peter Zijlstra <peterz@infradead.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Thread-Topic: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Thread-Index: AQHPIyHyPOWZ9aSzg0Cc3cR9rBWeq5qoBdGAgAAFU4CAAAY8gIAAAtoAgAE63wA=
Date: Fri, 7 Feb 2014 07:06:04 +0000
Message-ID: <1391756764.3973.56.camel@po-d-abo-ubu>
References: <20140206095646.GE17971@localhost>
	 <20140206112731.GH4941@twins.programming.kicks-ass.net>
	 <20140206114635.GA27429@localhost> <1391688533.8136.8.camel@po-d-abo-ubu>
	 <20140206121906.GJ4941@twins.programming.kicks-ass.net>
In-Reply-To: <20140206121906.GJ4941@twins.programming.kicks-ass.net>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A460173C8DF01E48B31678A5750FD3F6@precitecgroup.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s177CDnX010655

On Thu, 2014-02-06 at 13:19 +0100, Peter Zijlstra wrote: 
> On Thu, Feb 06, 2014 at 12:08:54PM +0000, Bockholdt Arne wrote:
> > This on a a Intel Rangeley Silvermont Atom 8 core machine running kernel
> > 3.13.1/i386 as KVM host with several KVM guests. Tested with the same
> > configuration on kernel 3.12.9 and 3.11.6 without the stall. The stall
> > is 100% reproducible when the KVM guests are under load.
> > Kernel 3.13.1 does NOT contain the patch below AFAIK.
> 
> 3.13 doesn't include 8cb75e0c4ec9786b81439761eac1d18d4a931af3 either.
> 
> can you try a recent linux.git? Also, can you test with a 64bit kernel
> too?


The machine isn't exactly a test box but I've tried to run the latest Linus 3.14-rc git and got an error about a symbol version mismatch (see below). I will try it again at the weekend when there is more time for tests like this.

Feb  6 21:25:45 kvm-server kernel: [    3.479594] usbhid: disagrees about version of symbol schedule_timeout
Feb  6 21:25:45 kvm-server kernel: [    3.479599] usbhid: Unknown symbol schedule_timeout (err -22)
Feb  6 21:25:45 kvm-server kernel: [    3.479819] usbhid: disagrees about version of symbol schedule_timeout
Feb  6 21:25:45 kvm-server kernel: [    3.479823] usbhid: Unknown symbol schedule_timeout (err -22)
Feb  6 21:25:45 kvm-server kernel: [    3.668097] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
Feb  6 21:25:45 kvm-server kernel: [    3.884211] random: init urandom read with 84 bits of entropy available
Feb  6 21:25:45 kvm-server kernel: [    4.180695] random: nonblocking pool is initialized
Feb  6 21:25:45 kvm-server kernel: [    4.213268] EXT4-fs (sdc1): re-mounted. Opts: errors=remount-ro,discard
Feb  6 21:25:45 kvm-server kernel: [    4.262349] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
Feb  6 21:25:45 kvm-server kernel: [    4.282062] ismt_smbus 0000:00:13.0: irq 53 for MSI/MSI-X
Feb  6 21:25:45 kvm-server kernel: [    4.289796] pps_core: disagrees about version of symbol schedule_timeout
Feb  6 21:25:45 kvm-server kernel: [    4.289803] pps_core: Unknown symbol schedule_timeout (err -22)
Feb  6 21:25:45 kvm-server kernel: [    4.292363] pps_core: disagrees about version of symbol schedule_timeout

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

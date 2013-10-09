Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3JIM4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:56:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:35263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab3JIM4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:56:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="sh'?scan'208";a="408264269"
Date: Wed, 9 Oct 2013 20:56:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131009125611.GA20450@localhost>
References: <20131005234430.GA22485@localhost>
 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
 <20131008143400.GA14721@redhat.com>
 <20131009080459.GA2298@localhost>
 <20131009121911.GA18770@localhost>
 <20131009122705.GG3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20131009122705.GG3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2013 at 02:27:05PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2013 at 08:19:11PM +0800, Fengguang Wu wrote:
> > > > Fengguang, I do not think this will help, but just in case. Could you
> > > > show the result of
> > > > 
> > > >         $ kernel/task_work.s
> > 
> > Update: I recompiled the kernel with gcc 4.4.7 and find it booting fine!
> 
> > # 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
> > 	bts $1, 8(%eax); setc %dl	#,, c
> 
> That compiler doesn't appear to have asm goto support, so we fall back
> to the code we already knew worked :-)

Ah OK..

btw, here is a simple script I used to reproduce the problem. I'll
attach the 3MB yocto initrd in another email. However I suspect
whatever initrd would be OK.

Thanks,
Fengguang

--qDbXVdCdHGoSgWSk
Content-Type: application/x-sh
Content-Disposition: attachment; filename="kvm-0day.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/bash=0A=0Akvm=3D(=0A	qemu-system-x86_64 -cpu kvm64 -enable-kvm=0A	-k=
ernel $1=0A	-initrd /kernel-tests/initrd/yocto-minimal-i386.cgz=0A	# -initr=
d /kernel-tests/initrd/quantal-core-i386.cgz=0A	# -initrd /kernel-tests/ini=
trd/quantal-core-x86_64.cgz=0A	-smp 2=0A	-m 256M=0A	-net nic,vlan=3D0,macad=
dr=3D00:00:00:00:00:00,model=3Dvirtio=0A	-net user,vlan=3D0=0A	-net nic,vla=
n=3D1,model=3De1000=0A	-net user,vlan=3D1=0A	-boot order=3Dnc=0A	-no-reboot=
=0A	-watchdog i6300esb=0A	-serial stdio=0A	-display none=0A	-monitor null=
=0A)=0A=0Aappend=3D(=0A	debug=0A	sched_debug=0A	ignore_loglevel=0A	apic=3Dd=
ebug=0A	dyndbg=3D\"func kobject_release +p\"=0A	sysrq_always_enabled=0A	pan=
ic=3D10=0A	prompt_ramdisk=3D0=0A	console=3DttyS0,115200=0A	console=3Dtty0=
=0A	vga=3Dnormal=0A	root=3D/dev/ram0=0A	rw=0A)=0A=0A"${kvm[@]}" --append "$=
{append[*]}"=0A
--qDbXVdCdHGoSgWSk--

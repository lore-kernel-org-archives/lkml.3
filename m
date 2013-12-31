Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab3LaTVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:21:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:42982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3LaTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:21:27 -0500
Date: Tue, 31 Dec 2013 14:21:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: halfdog <me@halfdog.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to
 other task
Message-ID: <20131231192106.GA22535@phenom.dumpdata.com>
References: <52BF4A80.3010503@halfdog.net>
 <52BF8AEE.6020904@zytor.com>
 <52C089AC.4000401@halfdog.net>
 <52C0C9F4.50101@zytor.com>
 <52C196C3.1040300@halfdog.net>
 <52C31027.2030101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C31027.2030101@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 10:42:47AM -0800, H. Peter Anvin wrote:
> On 12/30/2013 07:52 AM, halfdog wrote:
> >>
> >> Still in VirtualBox?
> > 
> > Yes, again: after comparing the results from initrd on real hardware
> > with Vbox, I'm getting to understand the timing problem involved and why
> > timing in VBox is different: The test program usually OOPSes when
> > touching FPU multiple times, otherwise, when terminated before second
> > FPU-interacation, it OOPSes on next invocation, stumbling over invalid
> > CPU state from prior invocation. With improved code, I can rather
> > reliably bring CPU into that state, so that next process invoked and
> > touching FPU/MMX-state is OOPSed. Currently searching SUID-binaries and
> > running UID=0 daemons, that might show interesting reaction on that
> > event, but only on DOS level yet, e.g. after running V2 test program
> > once and then connecting via SSH, this currently kills the ssh daemon
> > nicely.
> > 
> > It seems that machine lockup occurs when e.g. switch to idle task
> > happens at exactly the right moment, which I currently cannot trigger on
> > real hardware, but still working on that.
> > 
> 
> I'm still wondering if this is a VirtualBox-specific problem or if it is
> something that *could* occur on hardware, or in other virtualization
> environments (KVM, Xen HVM, Hy-perV, VMware etc.)

So, I am wondering if this is related to " x86/fpu: CR0.TS should be set before trap
into PV guest's #NM exception handle" which does have a similar pattern - you
do enough of the task switches and the FPU is screwed.

See http://mid.gmane.org/1383720072-6242-1-git-send-email-gaoyang.zyh@taobao.com

(I thought there was a thread about this on LKML too but I can't
find it).
> 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

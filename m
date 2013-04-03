Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000Ab3DCOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:46:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22218 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761759Ab3DCOqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:46:04 -0400
Date: Wed, 3 Apr 2013 10:46:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: Re: [PATCH] xen: Don't call arch_trigger_all_cpu_backtrace in
 dom0(pvm)
Message-ID: <20130403144600.GC6044@phenom.dumpdata.com>
References: <5155413E.6090002@oracle.com>
 <20130329134640.GG31356@phenom.dumpdata.com>
 <51591A8A.1060904@oracle.com>
 <20130401124118.GB11995@phenom.dumpdata.com>
 <515C19E5.2060309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515C19E5.2060309@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 08:00:37PM +0800, Zhenzhong Duan wrote:
> 
> On 2013-04-01 20:41, Konrad Rzeszutek Wilk wrote:
> >On Mon, Apr 01, 2013 at 01:26:34PM +0800, Zhenzhong Duan wrote:
> >>On 2013-03-29 21:46, Konrad Rzeszutek Wilk wrote:
> >>>On Fri, Mar 29, 2013 at 03:22:38PM +0800, Zhenzhong Duan wrote:
> >>The problem is even without overwrite, like xapic system,
> >>xen_send_IPI_all doesn't work for nmi vector.
> >Can you tweak the x2apic_mode = 0 in enligthen.c for example?
> >Or clear the X86_FEATURE_X2APIC in the enlighten.c ? (Similar
> >to how the other features are cleared) Wouldn't
> >that stop x2apic_enabled from detecting x2APIC?
> Hi Konrad,
> I used the second method. x2apic is totally masked in dom0. Thanks
> Tamon to do the test.
> 
> Testing result:
> 
> The server didn't get crashed by "echo l > /proc/sysrq-trigger". On this machine, VT-d is enabled in BIOS.
> However, no backtrace was shown.
> 
> [root@x4470m2-bur09-b ~]# uname -a
> Linux x4470m2-bur09-b.us.oracle.com 2.6.39-200.1.14.el5uek.bug16372098.test #1 SMP Tue Apr 2 21:09:27 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux
> [root@x4470m2-bur09-b ~]# cat /proc/cpuinfo | grep x2apic
> [root@x4470m2-bur09-b ~]# dmesg | grep x2apic
> [root@x4470m2-bur09-b ~]# cat /proc/cmdline
> ro root=UUID=486fc42b-3383-462f-aca3-b1340fbd4ad9 console=tty1 console=ttyS0,9600n8
> [root@x4470m2-bur09-b ~]# echo l > /proc/sysrq-trigger
> [root@x4470m2-bur09-b ~]#
> 
> /var/log/messages:
> (snip)
> Apr  3 14:14:33 x4470m2-bur09-b kernel: SysRq : Show backtrace of all active CPUs
> Apr  3 14:14:33 x4470m2-bur09-b kernel: sending NMI to all CPUs:
> (EOF)
> 
> On the console, no backtrace either. I did it twice, and got the same results.

Great.
Zhenzhong, do you want to prep a patch with a nice git commit description mentioning
your findings of the x2APIC over-write and also include the crach that would
appear?

And send it to xen-devel + LKML and to me so I can put it on my v3.9 branch?

Thanks
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611Ab3DCMAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:00:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17715 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760521Ab3DCMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:00:17 -0400
Message-ID: <515C19E5.2060309@oracle.com>
Date: Wed, 03 Apr 2013 20:00:37 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Feng Jin <joe.jin@oracle.com>, Tamon Shiose <tamon.shiose@oracle.com>
Subject: Re: [PATCH] xen: Don't call arch_trigger_all_cpu_backtrace in dom0(pvm)
References: <5155413E.6090002@oracle.com> <20130329134640.GG31356@phenom.dumpdata.com> <51591A8A.1060904@oracle.com> <20130401124118.GB11995@phenom.dumpdata.com>
In-Reply-To: <20130401124118.GB11995@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-04-01 20:41, Konrad Rzeszutek Wilk wrote:
> On Mon, Apr 01, 2013 at 01:26:34PM +0800, Zhenzhong Duan wrote:
>> On 2013-03-29 21:46, Konrad Rzeszutek Wilk wrote:
>>> On Fri, Mar 29, 2013 at 03:22:38PM +0800, Zhenzhong Duan wrote:
>> The problem is even without overwrite, like xapic system,
>> xen_send_IPI_all doesn't work for nmi vector.
> Can you tweak the x2apic_mode = 0 in enligthen.c for example?
> Or clear the X86_FEATURE_X2APIC in the enlighten.c ? (Similar
> to how the other features are cleared) Wouldn't
> that stop x2apic_enabled from detecting x2APIC?
Hi Konrad,
I used the second method. x2apic is totally masked in dom0. Thanks Tamon 
to do the test.

Testing result:

The server didn't get crashed by "echo l > /proc/sysrq-trigger". On this machine, VT-d is enabled in BIOS.
However, no backtrace was shown.

[root@x4470m2-bur09-b ~]# uname -a
Linux x4470m2-bur09-b.us.oracle.com 2.6.39-200.1.14.el5uek.bug16372098.test #1 SMP Tue Apr 2 21:09:27 PDT 2013 x86_64 x86_64 x86_64 GNU/Linux
[root@x4470m2-bur09-b ~]# cat /proc/cpuinfo | grep x2apic
[root@x4470m2-bur09-b ~]# dmesg | grep x2apic
[root@x4470m2-bur09-b ~]# cat /proc/cmdline
ro root=UUID=486fc42b-3383-462f-aca3-b1340fbd4ad9 console=tty1 console=ttyS0,9600n8
[root@x4470m2-bur09-b ~]# echo l > /proc/sysrq-trigger
[root@x4470m2-bur09-b ~]#

/var/log/messages:
(snip)
Apr  3 14:14:33 x4470m2-bur09-b kernel: SysRq : Show backtrace of all active CPUs
Apr  3 14:14:33 x4470m2-bur09-b kernel: sending NMI to all CPUs:
(EOF)

On the console, no backtrace either. I did it twice, and got the same results.



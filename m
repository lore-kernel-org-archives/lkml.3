Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbaCaBMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 21:12:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57541 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaCaBMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 21:12:37 -0400
From: Zhanghailiang <zhang.zhanghailiang@huawei.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhouxiangjiu <zhouxiangjiu@huawei.com>
Subject: Re: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Thread-Topic: VDSO pvclock may increase host cpu consumption, is this a
 problem?
Thread-Index: Ac9LK4P7lwEybLX9ToepDSfeMHiCof//3heA//08hoA=
Date: Mon, 31 Mar 2014 01:12:08 +0000
Message-ID: <D1BD20B5DB34024DA951CEEE6C4C59985961AE43@szxema505-mbs.china.huawei.com>
References: <D1BD20B5DB34024DA951CEEE6C4C59985961AD4E@szxema505-mbs.china.huawei.com>
 <20140329144607.GA20316@amt.cnet>
In-Reply-To: <20140329144607.GA20316@amt.cnet>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.22.69]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,
The CPU's info is:
processor       : 15
vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping        : 2
microcode       : 12
cpu MHz         : 2400.125
cache size      : 12288 KB
physical id     : 1
siblings        : 8
core id         : 10
cpu cores       : 4
apicid          : 53
initial apicid  : 53
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 popcnt aes lahf_lm arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 4800.18
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

Thanks
Zhang hailiang

> On Sat, Mar 29, 2014 at 08:47:27AM +0000, Zhanghailiang wrote:
> > Hi,
> > I found when Guest is idle, VDSO pvclock may increase host consumption.
> > We can calcutate as follow, Correct me if I am wrong.
> >       (Host)250 * update_pvclock_gtod = 1500 * gettimeofday(Guest) In
> > Host, VDSO pvclock introduce a notifier chain, pvclock_gtod_chain in
> timekeeping.c. It consume nearly 900 cycles per call. So in consideration of 250
> Hz, it may consume 225,000 cycles per second, even no VM is created.
> > In Guest, gettimeofday consumes 220 cycles per call with VDSO pvclock. If
> the no-kvmclock-vsyscall is configured, gettimeofday consumes 370 cycles per
> call. The feature decrease 150 cycles consumption per call.
> > When call gettimeofday 1500 times,it decrease 225,000 cycles,equal to the
> host consumption.
> > Both Host and Guest is linux-3.13.6.
> > So, whether the host cpu consumption is a problem?
> 
> Hi,
> 
> How many percents out of the total CPU cycles are 225,000 cycles, for your
> CPU ?


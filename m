Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaCBTFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 14:05:14 -0500
Received: from mout.web.de ([212.227.15.14]:59096 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaCBTFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 14:05:12 -0500
MIME-Version: 1.0
Message-ID: <trinity-7b67f319-33d3-4903-8156-553802be1838-1393787108760@3capp-webde-bs12>
From: "Roland Kletzing" <devzero@web.de>
To: chris.bainbridge@gmail.com
Cc: davej@redhat.com, hpa@zytor.com, julien.lavergne@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 2 Mar 2014 20:05:08 +0100
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:vH+aroqznNZtZ8b2rIqlql3KYNvbf1tZu+O52NwHs64
 qmFkgFeLyG5GpOUJ/4HRrcWuAbntJ3m/1Q75wNXmxta7klkUpD
 qTLhPad37aiG5JGu1Hk+tu0BpkGDVeQAhuaeUBSpFWavMSLiUW
 ha/ExnHcnBxNMoRDnZNL1g3JhtYWR58Zp9grH6tcch6B0HvU/V
 lyJYv54Oj1x0/KK6JmELuYGQs8InRJb1spg4Z0djjCksZOzdvJ
 cXoksZ9htCpDhr5gxsIHjbs5n0pqZ0bMjG/p+08cLiqIf6knvX
 fdcus0Awa7hrH6r/DHzU49vCJW9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

great to see that we have an enhaced version of the initial quick`n`dirty patch
now. i just tested it on ubuntu 13.10 with kernel from 14.04 repository (complete 
package build).

works as expected ! hopefully ubuntu #930447 can now be closed soon and the patch
will quickly find it´s way into trusty tahr. this is important, because windows xp 
is EOL`ed on 8th of april, and there will probably be lot`s of users with older 
notebooks try switching to lubuntu/xubuntu or whatever "PAE-only distro". 
( https://wiki.ubuntu.com/TrustyTahr/ReleaseSchedule )

i would recommend adding the newly introduced param to Documentation/kernel-
parameters.txt , though.

Thanks for your work !

Tested-by: Roland Kletzing <devzero@web.de>


root@ubuntu:/etc# uname -a
Linux ubuntu 3.13.0-14-generic #34 SMP Sat Mar 1 21:27:33 CET 2014 i686 i686 i686 GNU/Linux
root@ubuntu:/etc# dmesg |grep -C2 -i pae
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127870
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.13.0-14-generic root=UUID=9ee2e971-296c-4605-a26a-4f9854106ef8 ro crashkernel=384M-2G:64M,2G-:128M acpi=off forcepae
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
--
[    0.005403] Initializing cgroup subsys perf_event
[    0.005465] Initializing cgroup subsys hugetlb
[    0.005571] PAE forced!
[    0.005627] Disabling lock debugging due to kernel taint
[    0.005697] mce: CPU supports 5 MCE banks

root@ubuntu:/etc# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 9
model name      : Intel(R) Celeron(R) M processor         1300MHz
stepping        : 5
microcode       : 0x45
cpu MHz         : 1300.136
cache size      : 512 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 tm pbe bts
bogomips        : 2600.27
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 32 bits virtual
power management:



On Fri, Feb 28, 2014 at 03:27:50PM +0300, Dennis Mungai wrote:
> Hello people,
> 
> Note that revisions of the Dothan core were released in the first quarter
> of 2005 with the *Sonoma* chipsets and supported a 533 MT/s FSB and NX-bit
> (and PAE support required for it was enabled, unlike earlier Pentium Ms
> that had it disabled). These processors include the 730M (1.6 GHz), 740M
> (1.73 GHz), 750M (1.86 GHz), 760M (2.0 GHz) and 770M (2.13 GHz). These
> models all have a TDP of 27 W and a 2 MB L2 cache.
> 
> These CPUs should have PAE enabled. Only earlier versions of the Pentium M
> ( Older Dothans and the Banias core) do not have PAE support, officially.
> 
> -Dennis.

Good point, patch updated to not show the warning if PAE is already
enabled.

Signed-off-by: Chris Bainbridge <chris.bainbridge@gmail.com>

 	 */

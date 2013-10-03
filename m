Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab3JCKMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:12:00 -0400
Received: from mail-a01.ithnet.com ([217.64.83.96]:35409 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752274Ab3JCKL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:11:58 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 06:11:58 EDT
X-Sender-Authentication: SMTP AUTH verified <skraw>
Date: Thu, 3 Oct 2013 12:05:14 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: NUMA processor numbering
Message-Id: <20131003120514.36128d85.skraw@ithnet.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.24.18; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I have a box with this kind of processor (0-31) and 128 GB RAM:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-2660 0 @ 2.20GHz
stepping        : 7
microcode       : 0x70d
cpu MHz         : 2486.000
cache size      : 20480 KB
physical id     : 0
siblings        : 16
core id         : 0
cpu cores       : 8
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfp u pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt
tsc_deadline_tim er aes xsave avx lahf_lm ida arat xsaveopt pln pts dtherm
tpr_shadow vnmi flexpriority ept vpid 
bogomips        : 4400.12
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:


Now, numactl --hardware shows this:

available: 2 nodes (0-1)
node 0 cpus: 0 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30
node 0 size: 64581 MB
node 0 free: 12676 MB
node 1 cpus: 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31
node 1 size: 64637 MB
node 1 free: 10660 MB
node distances:
node   0   1 
  0:  10  20 
  1:  20  10 

Physically these are two processors with 8 Cores and 8 HT each.
Does the above output mean that the cores are numbered right across the two
physical cpus? Does this mean one has to pin processes to 0,2,4,... to stay in
"short distance" to node 0 RAM?
If so, it would be a lot better to have them numbered 0-15 and 16-31 for pinning.
Is there a way to achieve this?
Please cc me when answering.

-- 
Regards,
Stephan

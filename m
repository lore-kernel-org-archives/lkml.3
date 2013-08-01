Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3HAIyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:54:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:42374 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab3HAIyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,793,1367996400"; 
   d="scan'208";a="339995796"
Message-ID: <51FA220B.5070307@intel.com>
Date: Thu, 01 Aug 2013 16:53:31 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ilari Stenroth <ilari.stenroth@gmail.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <h.peter.anvin@intel.com>
Subject: Re: arch/x86/kernel/cpu/intel.c needs an update for Haswell?
References: <kt91u2$jhs$1@ger.gmane.org> <20130730193530.GB23299@pd.tnic> <kt951r$m5m$1@ger.gmane.org> <20130730195402.GD23299@pd.tnic>
In-Reply-To: <20130730195402.GD23299@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 03:54 AM, Borislav Petkov wrote:
> On Tue, Jul 30, 2013 at 10:44:02PM +0300, Ilari Stenroth wrote:
>> On 30.7.2013 22.35, Borislav Petkov wrote:
>>> On Tue, Jul 30, 2013 at 09:50:49PM +0300, Ilari Stenroth wrote:
>>>> Does somebody know why arch/x86/kernel/cpu/intel.c has
>>>> tlb_flushall_shift detection logic for Ivy Bridge CPU family but not
>>>> for Haswell? Maybe intel_cacheinfo.c needs to be checked for Haswell
>>>> updates too.
>>>
>>> Because someone needs to sit down and write it. Oh, and more
>>> importantly, test it on real hardware.
>>>
>>> :-)
>>>
>> Right :-) Can volunteer to test, only once I get a motherboard bug
>> fixed. It runs only one core. Poor Supermicro X10SLH-F thinks Xeon
>> E3-1265Lv3 has 1C2T :-/
> 
> Yeah, if I had to guess, I'd say the highest probability is for patches
> about it to be coming from Alex. :)
> 

just borrowed a haswell laptop and run the munmap case on this. :)
The cpu is 2 core * HT. The test show tlb_flushall_shift = 1 has best
performance.

tlb_flushall_shift is 1
=============== t = 2 
munmap use 243ms 14889ns/time, memory access uses 336949 times/thread/ms, cost 2ns/time
munmap use 152ms 18662ns/time, memory access uses 336561 times/thread/ms, cost 2ns/time
munmap use 60ms 14835ns/time, memory access uses 198710 times/thread/ms, cost 5ns/time
munmap use 41ms 20030ns/time, memory access uses 208748 times/thread/ms, cost 4ns/time
munmap use 21ms 20995ns/time, memory access uses 191849 times/thread/ms, cost 5ns/time
munmap use 21ms 41909ns/time, memory access uses 296545 times/thread/ms, cost 3ns/time
=============== t = 4 
munmap use 468ms 14287ns/time, memory access uses 72088 times/thread/ms, cost 13ns/time
munmap use 286ms 17488ns/time, memory access uses 65232 times/thread/ms, cost 15ns/time
munmap use 210ms 25746ns/time, memory access uses 97080 times/thread/ms, cost 10ns/time
munmap use 66ms 16138ns/time, memory access uses 56450 times/thread/ms, cost 17ns/time
munmap use 51ms 25323ns/time, memory access uses 41930 times/thread/ms, cost 23ns/time
munmap use 44ms 43599ns/time, memory access uses 53031 times/thread/ms, cost 18ns/time
munmap use 28ms 56011ns/time, memory access uses 36889 times/thread/ms, cost 27ns/time
=============== t = 8 
munmap use 2429ms 74138ns/time, memory access uses 42202 times/thread/ms, cost 23ns/time
munmap use 1079ms 65880ns/time, memory access uses 41497 times/thread/ms, cost 24ns/time
munmap use 623ms 76108ns/time, memory access uses 47844 times/thread/ms, cost 20ns/time
munmap use 387ms 94619ns/time, memory access uses 34652 times/thread/ms, cost 28ns/time
munmap use 90ms 44180ns/time, memory access uses 26498 times/thread/ms, cost 37ns/time
munmap use 49ms 47903ns/time, memory access uses 33863 times/thread/ms, cost 29ns/time
munmap use 26ms 51164ns/time, memory access uses 31491 times/thread/ms, cost 31ns/time

tlb_flush_shift is -1
=============== t = 2 
munmap use 418ms 12766ns/time, memory access uses 124215 times/thread/ms, cost 8ns/time
munmap use 184ms 11271ns/time, memory access uses 36519 times/thread/ms, cost 27ns/time
munmap use 116ms 14177ns/time, memory access uses 112472 times/thread/ms, cost 8ns/time
munmap use 66ms 16347ns/time, memory access uses 137546 times/thread/ms, cost 7ns/time
munmap use 43ms 21087ns/time, memory access uses 47053 times/thread/ms, cost 21ns/time
munmap use 31ms 30787ns/time, memory access uses 202638 times/thread/ms, cost 4ns/time
munmap use 22ms 43187ns/time, memory access uses 255272 times/thread/ms, cost 3ns/time
=============== t = 4 
munmap use 572ms 17483ns/time, memory access uses 54936 times/thread/ms, cost 18ns/time
munmap use 481ms 29360ns/time, memory access uses 71397 times/thread/ms, cost 14ns/time
munmap use 168ms 20575ns/time, memory access uses 59827 times/thread/ms, cost 16ns/time
munmap use 73ms 18062ns/time, memory access uses 34687 times/thread/ms, cost 28ns/time
munmap use 42ms 20581ns/time, memory access uses 48571 times/thread/ms, cost 20ns/time
munmap use 46ms 45261ns/time, memory access uses 43408 times/thread/ms, cost 23ns/time
munmap use 21ms 41828ns/time, memory access uses 49751 times/thread/ms, cost 20ns/time
=============== t = 8 
munmap use 1761ms 53756ns/time, memory access uses 40636 times/thread/ms, cost 24ns/time
munmap use 238ms 14541ns/time, memory access uses 19968 times/thread/ms, cost 50ns/time
munmap use 262ms 31988ns/time, memory access uses 31964 times/thread/ms, cost 31ns/time
munmap use 127ms 31086ns/time, memory access uses 35674 times/thread/ms, cost 28ns/time
munmap use 73ms 35764ns/time, memory access uses 23482 times/thread/ms, cost 42ns/time
munmap use 59ms 58406ns/time, memory access uses 36680 times/thread/ms, cost 27ns/time
munmap use 20ms 40608ns/time, memory access uses 26733 times/thread/ms, cost 37ns/time

------
>From 1322ea9e17ad4d9e49e2d93cfc04805368e28273 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 1 Aug 2013 16:30:23 +0800
Subject: [PATCH 2/2] tlb/tlb_flushall_shift: add haswell tlb_flush_shift

Tested on i5 4350U with munmap case, https://lkml.org/lkml/2012/5/17/59
The best performance is tlb_flush_shift = 1.
The balance point is 256 entries.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9a4bc51..ac9b83a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -627,6 +627,7 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 		tlb_flushall_shift = 5;
 		break;
 	case 0x63a: /* Ivybridge */
+	case 0x645: /* Haswell */
 		tlb_flushall_shift = 1;
 		break;
 	case 0x63e: /* Ivybridge EP */
-- 
1.7.12

-- 
Thanks
    Alex

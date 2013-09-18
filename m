Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3IRKsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:48:23 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54982 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab3IRKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:48:22 -0400
Message-ID: <523984BB.70208@linux.vnet.ibm.com>
Date: Wed, 18 Sep 2013 16:17:23 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 8/8][v4] powerpc/perf: Export Power7 memory hierarchy
 info to user space.
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com> <1379119755-21025-9-git-send-email-sukadev@linux.vnet.ibm.com>
In-Reply-To: <1379119755-21025-9-git-send-email-sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091810-8256-0000-0000-0000094691AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 06:19 AM, Sukadev Bhattiprolu wrote:
> On Power7, the DCACHE_SRC field in MMCRA register identifies the memory
> hierarchy level (eg: L2, L3 etc) from which a data-cache miss for a
> marked instruction was satisfied.
> 
> Use the 'perf_mem_data_src' object to export this hierarchy level to user
> space. Some memory hierarchy levels in Power7 don't map into the arch-neutral
> levels. However, since newer generation of the processor (i.e. Power8) uses
> fewer levels than in Power7, we don't really need to define new hierarchy
> levels just for Power7.
> 
> We instead, map as many levels as possible and approximate the rest. See
> comments near dcache-src_map[] in the patch.
> 
> Usage:
> 
> 	perf record -d -e 'cpu/PM_MRK_GRP_CMPL/' <application>
> 	perf report -n --mem-mode --sort=mem,sym,dso,symbol_daddr,dso_daddr"
> 
> 		For samples involving load/store instructions, the memory
> 		hierarchy level is shown as "L1 hit", "Remote RAM hit" etc.
> 	# or
> 
> 	perf record --data <application>
> 	perf report -D
> 
> 		Sample records contain a 'data_src' field which encodes the
> 		memory hierarchy level: Eg: data_src 0x442 indicates
> 		MEM_OP_LOAD, MEM_LVL_HIT, MEM_LVL_L2 (i.e load hit L2).

Successfully built and boot tested this entire patchset both on a P7 and P8 system.
Running some sample tests with ebizzy micro benchmark. Till now got only 0x142 and
0x0 values for data_src object for the sample records. Will experiment around bit
more on P7 and P8 systems and post the results.

Regards
Anshuman 


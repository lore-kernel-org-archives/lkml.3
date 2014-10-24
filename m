Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbaJXQba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:31:30 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:56643 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJXQb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:31:28 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Pintu Kumar <pintu.k@samsung.com>, akpm@linux-foundation.org,
        riel@redhat.com, pintu.k@samsung.com, aquini@redhat.com,
        paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, lauraa@codeaurora.org, gioh.kim@lge.com,
        mgorman@suse.de, rientjes@google.com, hannes@cmpxchg.org,
        vbabka@suse.cz, sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
In-Reply-To: <1413986796-19732-2-git-send-email-pintu.k@samsung.com>
Organization: http://mina86.com/
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com> <1413986796-19732-1-git-send-email-pintu.k@samsung.com> <1413986796-19732-2-git-send-email-pintu.k@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141024:aneesh.kumar@linux.vnet.ibm.com::2SMsb+ZFE6ShUQ1p:00000000000000000000000000000005Se
X-Hashcash: 1:20:141024:paul.gortmaker@windriver.com::VyHyghAz/bVJljf1:0000000000000000000000000000000000LyN
X-Hashcash: 1:20:141024:gioh.kim@lge.com::dn7Zph3IaD7oes55:00I1C
X-Hashcash: 1:20:141024:sasha.levin@oracle.com::dPG1e5y3Rwipmk0e:0000000000000000000000000000000000000000X2/
X-Hashcash: 1:20:141024:mgorman@suse.de::XeTrDjkw1Ij2OJSy:000YrL
X-Hashcash: 1:20:141024:kirill.shutemov@linux.intel.com::S2pWrufMIcsaF9pv:0000000000000000000000000000000WyO
X-Hashcash: 1:20:141024:lauraa@codeaurora.org::TMZPqKCAoNf0HoAz:00000000000000000000000000000000000000000lwd
X-Hashcash: 1:20:141024:jmarchan@redhat.com::yIrQrJNNfxPft+D/:0000000000000000000000000000000000000000000thk
X-Hashcash: 1:20:141024:pintu.k@samsung.com::cjQckciFbDHO3SrA:00000000000000000000000000000000000000000016B8
X-Hashcash: 1:20:141024:riel@redhat.com::mBBMFlbeZ4rPXK0g:001rBQ
X-Hashcash: 1:20:141024:vishnu.ps@samsung.com::Kvg1Geg3J/mclHLh:00000000000000000000000000000000000000001tsL
X-Hashcash: 1:20:141024:lcapitulino@redhat.com::hTWvCMx6aRKItJDX:0000000000000000000000000000000000000001+Ls
X-Hashcash: 1:20:141024:vbabka@suse.cz::AbF12WzfgfugizB8:0002UGz
X-Hashcash: 1:20:141024:linux-kernel@vger.kernel.org::QS0X5qyxzTgsSp51:0000000000000000000000000000000002/3M
X-Hashcash: 1:20:141024:linux-mm@kvack.org::g1SSV1XTsYe0/sZl:00000000000000000000000000000000000000000002tca
X-Hashcash: 1:20:141024:hannes@cmpxchg.org::lsHX+z1LzC4b9l+p:00000000000000000000000000000000000000000002x0D
X-Hashcash: 1:20:141024:pintu.k@samsung.com::nw0uHuX/LVuTjGP2:0000000000000000000000000000000000000000003H1U
X-Hashcash: 1:20:141024:aquini@redhat.com::fkLB/6v8MSHEhyB2:000000000000000000000000000000000000000000003YWY
X-Hashcash: 1:20:141024:akpm@linux-foundation.org::nM4r86H/Eajopi9c:0000000000000000000000000000000000003rzR
X-Hashcash: 1:20:141024:ed.savinay@samsung.com::Mr0ZCfoXQZsVYQBi:0000000000000000000000000000000000000003aRV
X-Hashcash: 1:20:141024:rientjes@google.com::Jbp4ULP6ehBRAo7Z:0000000000000000000000000000000000000000003lRh
X-Hashcash: 1:20:141024:iamjoonsoo.kim@lge.com::1f8ejSLk6n/RTKqs:0000000000000000000000000000000000000006qCI
X-Hashcash: 1:20:141024:pintu_agarwal@yahoo.com::9Ti5G7r99T8V6nks:000000000000000000000000000000000000008I+4
X-Hashcash: 1:20:141024:cpgs@samsung.com::kxKMngCBoeBlwphy:098Mk
X-Hashcash: 1:20:141024:m.szyprowski@samsung.com::FJCQoBX2YmlIh2A0:0000000000000000000000000000000000000BLMm
X-Hashcash: 1:20:141024:rohit.kr@samsung.com::Joe6oybxA9a2iLRP:000000000000000000000000000000000000000009cMJ
Date: Fri, 24 Oct 2014 18:31:21 +0200
Message-ID: <xa1tk33p2zvq.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22 2014, Pintu Kumar <pintu.k@samsung.com> wrote:
> This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
> Currently, in a CMA enabled system, if somebody wants to know the
> total CMA size declared, there is no way to tell, other than the dmesg
> or /var/log/messages logs.
> With this patch we are showing the CMA info as part of meminfo, so that
> it can be determined at any point of time.
> This will be populated only when CMA is enabled.
>
> Below is the sample output from a ARM based device with RAM:512MB and CMA:16MB.
>
> MemTotal:         471172 kB
> MemFree:          111712 kB
> MemAvailable:     271172 kB
> .
> .
> .
> CmaTotal:          16384 kB
> CmaFree:            6144 kB
>
> This patch also fix below checkpatch errors that were found during these changes.

As already mentioned, this should be in separate patch.

>
> ERROR: space required after that ',' (ctx:ExV)
> 199: FILE: fs/proc/meminfo.c:199:
> +       ,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
>         ^
>
> ERROR: space required after that ',' (ctx:ExV)
> 202: FILE: fs/proc/meminfo.c:202:
> +       ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>         ^
>
> ERROR: space required after that ',' (ctx:ExV)
> 206: FILE: fs/proc/meminfo.c:206:
> +       ,K(totalcma_pages)
>         ^
>
> total: 3 errors, 0 warnings, 2 checks, 236 lines checked
>
> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  fs/proc/meminfo.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index aa1eee0..d3ebf2e 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -12,6 +12,9 @@
>  #include <linux/vmstat.h>
>  #include <linux/atomic.h>
>  #include <linux/vmalloc.h>
> +#ifdef CONFIG_CMA
> +#include <linux/cma.h>
> +#endif
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>  #include "internal.h"
> @@ -138,6 +141,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  		"AnonHugePages:  %8lu kB\n"
>  #endif
> +#ifdef CONFIG_CMA
> +		"CmaTotal:       %8lu kB\n"
> +		"CmaFree:        %8lu kB\n"
> +#endif
>  		,
>  		K(i.totalram),
>  		K(i.freeram),
> @@ -187,12 +194,16 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		vmi.used >> 10,
>  		vmi.largest_chunk >> 10
>  #ifdef CONFIG_MEMORY_FAILURE
> -		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
> +		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
>  #endif
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
> +		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>  		   HPAGE_PMD_NR)
>  #endif
> +#ifdef CONFIG_CMA
> +		, K(totalcma_pages)
> +		, K(global_page_state(NR_FREE_CMA_PAGES))
> +#endif
>  		);
>  
>  	hugetlb_report_meminfo(m);
> -- 
> 1.7.9.5
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

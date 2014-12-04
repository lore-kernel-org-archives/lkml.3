Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaLDQ0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:26:35 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62402 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDQ0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:26:33 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Xishi Qiu <qiuxishi@huawei.com>, Andrew Morton <akpm@linux-foundation.org>,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH] CMA: add the amount of cma memory in meminfo
In-Reply-To: <547FCCE9.2020600@huawei.com>
Organization: http://mina86.com/
References: <547FCCE9.2020600@huawei.com>
User-Agent: Notmuch/0.19~rc1+1~g03aea4f (http://notmuchmail.org) Emacs/25.0.50.3 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141204:linux-mm@kvack.org::M7dI76AoPwWFpkYW:000000000000000000000000000000000000000000001Ii
X-Hashcash: 1:20:141204:qiuxishi@huawei.com::s6Fkp1Be2pMMH76C:00000000000000000000000000000000000000000007VM
X-Hashcash: 1:20:141204:akpm@linux-foundation.org::Jub1WJKu+DWiJvi4:0000000000000000000000000000000000001SoO
X-Hashcash: 1:20:141204:linux-kernel@vger.kernel.org::9iFChUaHVz9DPqhg:00000000000000000000000000000000023nX
X-Hashcash: 1:20:141204:iamjoonsoo.kim@lge.com::LxJaPCK7gknGk5RQ:0000000000000000000000000000000000000002NRH
X-Hashcash: 1:20:141204:m.szyprowski@samsung.com::oatjg33r9H2VjJvZ:00000000000000000000000000000000000002K8r
X-Hashcash: 1:20:141204:qiuxishi@huawei.com::gAdzMuQvclecvEVr:0000000000000000000000000000000000000000004cLC
X-Hashcash: 1:20:141204:aneesh.kumar@linux.vnet.ibm.com::86Wrxwp4iw/pDKSc:000000000000000000000000000000AzQQ
Date: Thu, 04 Dec 2014 17:26:29 +0100
Message-ID: <xa1tfvcvcrey.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2014, Xishi Qiu <qiuxishi@huawei.com> wrote:
> Add the amount of cma memory in the following meminfo.
> /proc/meminfo
> /sys/devices/system/node/nodeXX/meminfo
>
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  drivers/base/node.c | 16 ++++++++++------
>  fs/proc/meminfo.c   | 12 +++++++++---
>  2 files changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 472168c..a27e4e0 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -120,6 +120,9 @@ static ssize_t node_read_meminfo(struct device *dev,
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  		       "Node %d AnonHugePages:  %8lu kB\n"
>  #endif
> +#ifdef CONFIG_CMA
> +		       "Node %d FreeCMAPages:   %8lu kB\n"
> +#endif
>  			,
>  		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
>  		       nid, K(node_page_state(nid, NR_WRITEBACK)),
> @@ -136,14 +139,15 @@ static ssize_t node_read_meminfo(struct device *dev,
>  		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
>  				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
>  		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))

Why is this line suddenly out of “#ifdef CONFIG_TRANSPARENT_HUGEPAGE”?

> -			, nid,
> -			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
> -			HPAGE_PMD_NR));
> -#else
> -		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE)));
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +		       , nid, K(node_page_state(nid,
> +				NR_ANON_TRANSPARENT_HUGEPAGES) * HPAGE_PMD_NR)

This is mere white-space change which is confusing.

> +#endif
> +#ifdef CONFIG_CMA
> +		       , nid, K(node_page_state(nid, NR_FREE_CMA_PAGES))
>  #endif
> +			);
>  	n += hugetlb_report_node_meminfo(nid, buf + n);
>  	return n;
>  }
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index aa1eee0..d42e082 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -138,6 +138,9 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  		"AnonHugePages:  %8lu kB\n"
>  #endif
> +#ifdef CONFIG_CMA
> +		"FreeCMAPages:   %8lu kB\n"
> +#endif
>  		,
>  		K(i.totalram),
>  		K(i.freeram),
> @@ -187,11 +190,14 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  		vmi.used >> 10,
>  		vmi.largest_chunk >> 10
>  #ifdef CONFIG_MEMORY_FAILURE
> -		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
> +		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
>  #endif
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
> -		   HPAGE_PMD_NR)
> +		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
> +				HPAGE_PMD_NR)
> +#endif

Again, please don't include white space changes.  They are confusing.

> +#ifdef CONFIG_CMA
> +		, K(global_page_state(NR_FREE_CMA_PAGES))
>  #endif
>  		);
>  
> -- 
> 2.0.0
>
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaH3BZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:25:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaH3BZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:25:01 -0400
Message-ID: <540127AC.4040804@oracle.com>
Date: Fri, 29 Aug 2014 21:23:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com> <53E989FB.5000904@oracle.com> <53FD4D9F.6050500@oracle.com> <20140827152622.GC12424@suse.de>
In-Reply-To: <20140827152622.GC12424@suse.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 11:26 AM, Mel Gorman wrote:
> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
> index 281870f..ffea570 100644
> --- a/include/asm-generic/pgtable.h
> +++ b/include/asm-generic/pgtable.h
> @@ -723,6 +723,9 @@ static inline pte_t pte_mknuma(pte_t pte)
>  
>  	VM_BUG_ON(!(val & _PAGE_PRESENT));
>  
> +	/* debugging only, specific to x86 */
> +	VM_BUG_ON(val & _PAGE_PROTNONE);
> +
>  	val &= ~_PAGE_PRESENT;
>  	val |= _PAGE_NUMA;

Triggered again, the first VM_BUG_ON got hit, the second one never did.


Thanks,
Sasha

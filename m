Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3CYC2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:28:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab3CYC2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:28:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,342,1363104000"; 
   d="scan'208";a="6935187"
Message-ID: <514FB24F.8080104@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 10:11:27 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Russ Anderson <rja@sgi.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [patch] mm: speedup in __early_pfn_to_nid
References: <20130318155619.GA18828@sgi.com> <20130321105516.GC18484@gmail.com> <alpine.DEB.2.02.1303211139110.3775@chino.kir.corp.google.com> <20130322072532.GC10608@gmail.com> <20130323152948.GA3036@sgi.com> <CAE9FiQUjVRUs02-ymmtO+5+SgqTWK8Ae6jJwD08uRbgR=eLJgw@mail.gmail.com>
In-Reply-To: <CAE9FiQUjVRUs02-ymmtO+5+SgqTWK8Ae6jJwD08uRbgR=eLJgw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 10:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/25 10:08:52,
	Serialize complete at 2013/03/25 10:08:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/24/2013 04:37 AM, Yinghai Lu wrote:
> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
> +			 unsigned long *start_pfn, unsigned long *end_pfn)
> +{
> +	struct memblock_type *type = &memblock.memory;
> +	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);

I'm really eager to see how much time can we save using binary search compared to
linear search in this case :)

(quote)
> A 4 TB (single rack) UV1 system takes 512 seconds to get through
> the zone code.  This performance optimization reduces the time
> by 189 seconds, a 36% improvement.
>
> A 2 TB (single rack) UV2 system goes from 212.7 seconds to 99.8 seconds,
> a 112.9 second (53%) reduction.
(quote)

thanks,
linfeng

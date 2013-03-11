Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3CKG3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:29:51 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58902 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3CKG3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <513D7078.9080507@cn.fujitsu.com>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
	<1362897887-30808-21-git-send-email-yinghai@kernel.org>
	<513D7078.9080507@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 23:29:49 -0700
X-Google-Sender-Auth: wwtt5DGWbn-qYtGFi3A9da3CNZI
Message-ID: <CAE9FiQXKxnx5kiuz6zfcfS4pKJJu6GOR6CWso-wKcZuHBaAzbQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] x86, mm, numa: Put pagetable on local node ram
 for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 10:49 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> On 03/10/2013 02:44 PM, Yinghai Lu wrote:
>>
>> Calling init_mem_mapping in early_initmem_init for every node.
>> alloc_low_pages will alloc page table in following order:
>>         BRK, local node, low range
>> So page table will be on low range or local nodes.
...
> IIUC, we call init_mem_mapping() for each node ranges. In the first time,
>         local_max_pfn_mapped = begin >> PAGE_SHIFT;
>         local_min_pfn_mapped = real_end >> PAGE_SHIFT;
> which means
>         local_min_pfn_mapped >= local_max_pfn_mapped
> right ?
>
> So, the first page allocated by alloc_low_pages() is not on local node,
> right ?

It is from BRK with kernel code.

> Furthermore, the first page of pagetable is not on local node, right ?

It is in BRK for node with start = 0.

Other node, it is from low_range aka node with start = 0.

Thanks

Yinghai

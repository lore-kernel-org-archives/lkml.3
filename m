Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3CKU2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:28:07 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:58068 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CKU2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:28:05 -0400
MIME-Version: 1.0
In-Reply-To: <20130311131601.GG23018@phenom.dumpdata.com>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
	<1362897887-30808-20-git-send-email-yinghai@kernel.org>
	<20130311131601.GG23018@phenom.dumpdata.com>
Date: Mon, 11 Mar 2013 13:28:03 -0700
X-Google-Sender-Auth: qOq6Ng0Ed3HiSy9bR8gLjbS9xMM
Message-ID: <CAE9FiQWhR9SG1WyqCCxKS2PkJXKeO-wpxQsuUN8_evKWebpAiA@mail.gmail.com>
Subject: Re: [PATCH v2 19/20] x86, mm: Make init_mem_mapping be able to be
 called several times
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 6:16 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Sat, Mar 09, 2013 at 10:44:46PM -0800, Yinghai Lu wrote:
>> Prepare to put page table on local nodes.
>>
>> Move calling of init_mem_mapping to early_initmem_init.
>>
>> Rework alloc_low_pages to alloc page table in following order:
>>       BRK, local node, low range
>>
>> Still only load_cr3 one time, otherwise we would break xen 64bit again.
>>
>
> We could also fix that. Now that the regression storm has passed
> and I am able to spend some time on it we could make it a bit more
> resistant.

Never mind, We should only need to call load_cr3 one time.

as init_memory_mapping itself flush tlb everytime on 64bit.

Thanks

Yinghai

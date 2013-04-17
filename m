Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829Ab3DQGq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:46:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47908 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965812Ab3DQGq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:46:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516E452A.7060703@jp.fujitsu.com>
Date: Wed, 17 Apr 2013 15:46:02 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <toshi.kani@hp.com>,
        <linuxram@us.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v3] Reusing a resource structure allocated by
 bootmem
References: <516DEC34.7040008@jp.fujitsu.com> <alpine.DEB.2.02.1304161733340.14583@chino.kir.corp.google.com> <516E2305.3060705@jp.fujitsu.com> <alpine.DEB.2.02.1304162144320.3493@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304162144320.3493@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2013/04/17 13:47, David Rientjes wrote:
> On Wed, 17 Apr 2013, Yasuaki Ishimatsu wrote:
>
>>> Why not simply do what generic sparsemem support does by testing
>>> PageSlab(virt_to_head_page(res)) and calling kfree() if true and freeing
>>> back to bootmem if false?  This should be like a five line patch.
>>
>> Is your explanation about free_section_usemap()?
>> If so, I don't think we can release resource structure like
>> free_section_usemap().
>

> Right, you can't release it like free_section_usemap(), but you're free to
> test for PageSlab(virt_to_head_page(res)) in kernel/resource.c.

O.K. I'll update it.

>
>> In your explanation case, memmap can be released by put_page_bootmem() in
>> free_map_bootmem() since all pages of memmap is used only for memmap.
>> But if my understanding is correct, a page of released resource structure
>> contain other purpose objects allocated by bootmem. So we cannot
>> release resource structure like free_section_usemap().
>>
>
> I'm thinking it would be much easier to just suppress the kfree() if
> !PageSlab.  If you can free an entire page with free_bootmem_late(),
> that would be great,

> but I'm thinking that will take more work than it's
> worth.  It seems fine to just do free_bootmem() and leave those pages as
> reserved.

I think so, too.

> How much memory are we talking about?

Hmm. I don't know correctly.

Here is kernel message of my system. The message is shown by mem_init().

-- 
Memory: 30491076k/33554432k available (5570k kernel code, 2274228k absent, 789128k reserved, 5667k data, 1784k init)
---

Reserved memroy size is 789128k. So part of them is freed after system boot
by  memory hotplug  et al.

Thanks,
Yasuaki Ishimatsu



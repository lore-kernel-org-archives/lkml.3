Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3EPXqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 19:46:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48389 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3EPXqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 19:46:06 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51956FA3.6040806@jp.fujitsu.com>
Date: Fri, 17 May 2013 08:45:39 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "riel@redhat.com" <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        jingbai.ma@hp.com, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, lisa.mitchell@hp.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        kumagai-atsushi@mxc.nes.nec.co.jp,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        zhangyanfei@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, cpw@sgi.com, vgoyal@redhat.com
Subject: Re: [PATCH v6 4/8] vmalloc: make find_vm_area check in range
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <20130515090602.28109.90142.stgit@localhost6.localdomain6> <CAHGf_=q-91cYOMPFfSGLsWWst7STgp6pxX4__9UMYUGh=Ef3oA@mail.gmail.com>
In-Reply-To: <CAHGf_=q-91cYOMPFfSGLsWWst7STgp6pxX4__9UMYUGh=Ef3oA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/16 6:37), KOSAKI Motohiro wrote:
> On Wed, May 15, 2013 at 5:06 AM, HATAYAMA Daisuke
> <d.hatayama@jp.fujitsu.com> wrote:
>> Currently, __find_vmap_area searches for the kernel VM area starting
>> at a given address. This patch changes this behavior so that it
>> searches for the kernel VM area to which the address belongs. This
>> change is needed by remap_vmalloc_range_partial to be introduced in
>> later patch that receives any position of kernel VM area as target
>> address.
>>
>> This patch changes the condition (addr > va->va_start) to the
>> equivalent (addr >= va->va_end) by taking advantage of the fact that
>> each kernel VM area is non-overlapping.
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>
>>   mm/vmalloc.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index d365724..3875fa2 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -292,7 +292,7 @@ static struct vmap_area *__find_vmap_area(unsigned long addr)
>>                  va = rb_entry(n, struct vmap_area, rb_node);
>>                  if (addr < va->va_start)
>>                          n = n->rb_left;
>> -               else if (addr > va->va_start)
>> +               else if (addr >= va->va_end)
>>                          n = n->rb_right;
>
> OK. This is natural definition. Looks good.
>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks for your reviewing. Could you or other someone review the next 
5/8 patch too? It also changes vmalloc and cc people's review is needed.

-- 
Thanks.
HATAYAMA, Daisuke


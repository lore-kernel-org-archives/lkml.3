Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbaDKRYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:24:46 -0400
Received: from relay.parallels.com ([195.214.232.42]:40105 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaDKRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:24:43 -0400
Message-ID: <53482555.4070603@parallels.com>
Date: Fri, 11 Apr 2014 21:24:37 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <akpm@linux-foundation.org>, <penberg@kernel.org>, <gthelen@google.com>,
        <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <devel@openvz.org>
Subject: Re: [PATCH -mm] slab: document kmalloc_order
References: <20140410163831.c76596b0f8d0bef39a42c63f@linux-foundation.org> <1397220736-13840-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.10.1404111057390.13278@nuc>
In-Reply-To: <alpine.DEB.2.10.1404111057390.13278@nuc>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 07:57 PM, Christoph Lameter wrote:
> On Fri, 11 Apr 2014, Vladimir Davydov wrote:
>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index cab4c49b3e8c..3ffd2e76b5d2 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -573,6 +573,11 @@ void __init create_kmalloc_caches(unsigned long flags)
>>  }
>>  #endif /* !CONFIG_SLOB */
>>
>> +/*
>> + * To avoid unnecessary overhead, we pass through large allocation requests
>> + * directly to the page allocator. We use __GFP_COMP, because we will need to
>> + * know the allocation order to free the pages properly in kfree.
>> + */
>>  void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
>>  {
>>  	void *ret;
>>
> ??? kmalloc_order is defined in include/linux/slab.h

I moved it to slab_common.c in "[PATCH -mm v2.2] mm: get rid of
__GFP_KMEMCG"

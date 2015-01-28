Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbbA1WBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:01:33 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39101 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500AbbA1UYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:33 -0500
X-Sasl-enc: YGgZlPWkMqbDUyaBSJdNWjXdmGwuHO+Gp6c4UAhh0TSC 1422469764
Message-ID: <54C92A82.10805@iki.fi>
Date: Wed, 28 Jan 2015 20:29:22 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>,
        Vladimir Davydov <vdavydov@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2 1/3] slub: never fail to shrink cache
References: <cover.1422461573.git.vdavydov@parallels.com> <012683fc3a0f9fb20a288986fd63fe9f6d25e8ee.1422461573.git.vdavydov@parallels.com> <alpine.DEB.2.11.1501281031190.32147@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1501281031190.32147@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/15 6:31 PM, Christoph Lameter wrote:
> On Wed, 28 Jan 2015, Vladimir Davydov wrote:
>
>> This patch therefore makes __kmem_cache_shrink() allocate the array on
>> stack instead of calling kmalloc, which may fail. The array size is
>> chosen to be equal to 32, because most SLUB caches store not more than
>> 32 objects per slab page. Slab pages with <= 32 free objects are sorted
>> using the array by the number of objects in use and promoted to the head
>> of the partial list, while slab pages with > 32 free objects are left in
>> the end of the list without any ordering imposed on them.
> Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Pekka Enberg <penberg@kernel.org>

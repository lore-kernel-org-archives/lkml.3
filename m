Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3JVFvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:51:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3JVFvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:51:22 -0400
X-IronPort-AV: E=Sophos;i="4.93,546,1378828800"; 
   d="scan'208";a="8824072"
Message-ID: <52660D7A.9070007@cn.fujitsu.com>
Date: Tue, 22 Oct 2013 13:30:34 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: introduce f2fs_kmem_cache_alloc to hide the unfailed
 kmem cache allocation
References: <5264D6C7.9000202@cn.fujitsu.com> <5265F5E6.3000604@cn.fujitsu.com>
In-Reply-To: <5265F5E6.3000604@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 13:33:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 13:48:48,
	Serialize complete at 2013/10/22 13:48:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 11:49 AM, Gao feng wrote:

> On 10/21/2013 03:24 PM, Gu Zheng wrote:
>> +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
>> +						gfp_t flags)
>> +{
>> +	void *entry = kmem_cache_alloc(cachep, flags);
>> +retry:
> 
> retry after kmem_cache_alloc?

Oh~, stupid mistake, thanks for your reminder.:)

> 
>> +	if (!entry) {
>> +		cond_resched();
>> +		goto retry;
>> +	}
>> +
>> +	return entry;
>> +}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



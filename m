Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3JVFvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 01:51:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13320 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3JVFvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 01:51:33 -0400
X-IronPort-AV: E=Sophos;i="4.93,546,1378828800"; 
   d="scan'208";a="8824078"
Message-ID: <52660E62.9090409@cn.fujitsu.com>
Date: Tue, 22 Oct 2013 13:34:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Haicheng Li <haicheng.li@linux.intel.com>
CC: Gao feng <gaofeng@cn.fujitsu.com>, Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: introduce f2fs_kmem_cache_alloc to hide the unfailed
 kmem cache allocation
References: <5264D6C7.9000202@cn.fujitsu.com> <5265F5E6.3000604@cn.fujitsu.com> <20131022051636.GJ21006@hli22-desktop>
In-Reply-To: <20131022051636.GJ21006@hli22-desktop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 13:37:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/22 13:49:04,
	Serialize complete at 2013/10/22 13:49:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 01:16 PM, Haicheng Li wrote:

> On Tue, Oct 22, 2013 at 11:49:58AM +0800, Gao feng wrote:
>> On 10/21/2013 03:24 PM, Gu Zheng wrote:
>>> +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
>>> +						gfp_t flags)
>>> +{
>>> +	void *entry = kmem_cache_alloc(cachep, flags);
>>> +retry:
>>
>> retry after kmem_cache_alloc?
> 
> Good catch.
> 
> Sorry for the carelessness in my previous review. 
> Besides this, I also found another issue as below:
>  
>> On Mon, Oct 21, 2013 at 03:24:55PM +0800, Gu Zheng wrote: 
>>> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c 
>>> index ef80f79..fe3cf8e 100644 
>>> --- a/fs/f2fs/node.c 
>>> +++ b/fs/f2fs/node.c 
>>> @@ -1308,11 +1308,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build) 
>>>     if (allocated) 
>>>             return 0; 
>>>  retry: 
> -retry?

Can be removed here, this tag still used by front goto jumping. But it
seems that we need to use another suitable name rather than "retry".

Regards,
Gu
> 

> 



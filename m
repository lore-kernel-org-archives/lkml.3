Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883Ab3BEFHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:07:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43954 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3BEFHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:07:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,603,1355068800"; 
   d="scan'208";a="6690059"
Message-ID: <51109352.9070401@cn.fujitsu.com>
Date: Tue, 05 Feb 2013 13:06:26 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tang chen <tangchen@cn.fujitsu.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] fs/aio.c: use get_user_pages_non_movable() to pin
 ring pages when support memory hotremove
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <1359972248-8722-3-git-send-email-linfeng@cn.fujitsu.com> <x49ehgw85w4.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ehgw85w4.fsf@segfault.boston.devel.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:06:30,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/05 13:06:34,
	Serialize complete at 2013/02/05 13:06:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On 02/04/2013 11:18 PM, Jeff Moyer wrote:
>> ---
>>  fs/aio.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 71f613c..0e9b30a 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -138,9 +138,15 @@ static int aio_setup_ring(struct kioctx *ctx)
>>  	}
>>  
>>  	dprintk("mmap address: 0x%08lx\n", info->mmap_base);
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +	info->nr_pages = get_user_pages_non_movable(current, ctx->mm,
>> +					info->mmap_base, nr_pages,
>> +					1, 0, info->ring_pages, NULL);
>> +#else
>>  	info->nr_pages = get_user_pages(current, ctx->mm,
>>  					info->mmap_base, nr_pages, 
>>  					1, 0, info->ring_pages, NULL);
>> +#endif
> 
> Can't you hide this in your 1/1 patch, by providing this function as
> just a static inline wrapper around get_user_pages when
> CONFIG_MEMORY_HOTREMOVE is not enabled?
Good idea, it makes the callers more neatly :)

thanks,
linfeng

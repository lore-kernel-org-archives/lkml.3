Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3KDCdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 21:33:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59013 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab3KDCdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 21:33:20 -0500
X-IronPort-AV: E=Sophos;i="4.93,629,1378828800"; 
   d="scan'208";a="8937031"
Message-ID: <527705F3.50407@cn.fujitsu.com>
Date: Mon, 04 Nov 2013 10:26:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: bpm@sgi.com, elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: simplify kmem_{zone_}zalloc
References: <52738187.1000807@cn.fujitsu.com> <20131101205803.GQ4446@dastard>
In-Reply-To: <20131101205803.GQ4446@dastard>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/04 10:31:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/04 10:31:17,
	Serialize complete at 2013/11/04 10:31:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,
On 11/02/2013 04:58 AM, Dave Chinner wrote:

> On Fri, Nov 01, 2013 at 06:25:11PM +0800, Gu Zheng wrote:
>> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
>> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
>> in order to avoid the setting to zero step.
>>
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/xfs/kmem.c |   14 ++------------
>>  fs/xfs/kmem.h |    7 ++++++-
>>  2 files changed, 8 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
>> index a02cfb9..d56fcc9 100644
>> --- a/fs/xfs/kmem.c
>> +++ b/fs/xfs/kmem.c
>> @@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>>  void *
>>  kmem_zalloc(size_t size, xfs_km_flags_t flags)
>>  {
>> -	void	*ptr;
>> -
>> -	ptr = kmem_alloc(size, flags);
>> -	if (ptr)
>> -		memset((char *)ptr, 0, (int)size);
>> -	return ptr;
>> +	return kmem_alloc(size, flags | KM_ZERO);
>>  }
>>  
>>  void *
>> @@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>>  void *
>>  kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>>  {
>> -	void	*ptr;
>> -
>> -	ptr = kmem_zone_alloc(zone, flags);
>> -	if (ptr)
>> -		memset((char *)ptr, 0, kmem_cache_size(zone));
>> -	return ptr;
>> +	return kmem_zone_alloc(zone, flags | KM_ZERO);
>>  }
> 
> These functions should be made static inline functions in kmem.h
> seeing as they are now just a simple wrapper.

Agree. Thanks for your suggestion, I'll follow it.

> 
> Otherwise it's a nice cleanup.

Thanks:)

Regards,
Gu

> 
> Cheers,
> 
> Dave.



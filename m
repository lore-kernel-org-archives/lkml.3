Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937009Ab3DKCxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 22:53:31 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39297 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936550Ab3DKCx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 22:53:29 -0400
Message-ID: <516625A7.9020403@inktank.com>
Date: Wed, 10 Apr 2013 21:53:27 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Laurent Barbe <laurent@ksperis.com>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rbd: revalidate_disk upon rbd resize
References: <1365609989-14493-1-git-send-email-laurent@ksperis.com> <5165BDE1.7010908@inktank.com>
In-Reply-To: <5165BDE1.7010908@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 02:30 PM, Alex Elder wrote:
> On 04/10/2013 11:06 AM, Laurent Barbe wrote:
>> If rbd disk is open and rbd resize is done, new size is not visible by
>> filesystem.
>> Like is done in virtio-blk and dm driver, revalidate_disk() permits to
>> update the bd_inode size.
> 
> Looks good to me.  I'll take this in via the ceph-client tree.
> Thanks a lot.

Unfortunately this leads to a lock inversion.  I'm going to
think about how to go about resolving it, so I won't be
committing it just yet.

					-Alex

> 
> Reviewed-by: Alex Elder <elder@inktank.com>
> 
>> Signed-off-by: Laurent Barbe <laurent@ksperis.com>
>> ---
>>  drivers/block/rbd.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index f556f8a..1963025 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -2293,6 +2293,7 @@ static void rbd_update_mapping_size(struct rbd_device *rbd_dev)
>>  	dout("setting size to %llu sectors", (unsigned long long) size);
>>  	rbd_dev->mapping.size = (u64) size;
>>  	set_capacity(rbd_dev->disk, size);
>> +	revalidate_disk(rbd_dev->disk);
>>  }
>>  
>>  /*
>>
> 


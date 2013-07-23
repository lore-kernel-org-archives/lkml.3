Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3GWB1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:27:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3GWB1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:27:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,722,1367942400"; 
   d="scan'208";a="7984804"
Message-ID: <51EDDB36.8020904@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 09:24:06 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: add the missing delection of orphan inode entry
 in write_orphan_inodes()
References: <51E8F65F.9040007@cn.fujitsu.com> <1374497479.26443.20.camel@kjgkr>
In-Reply-To: <1374497479.26443.20.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:25:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:25:43
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 08:51 PM, Jaegeuk Kim wrote:

> Hi,
> 
> 2013-07-19 (금), 16:18 +0800, Gu Zheng:
>> After writing orphan inode entry in jornal block, we need to delete each
>> entry from the orphan entry list, and release them.
>>
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/checkpoint.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index 66a6b85..290db04 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -337,6 +337,10 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
>>  		memset(orphan_blk, 0, sizeof(*orphan_blk));
>>  page_exist:
>>  		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
>> +
>> +		list_del(&orphan->list);
>> +		kmem_cache_free(orphan_entry_slab, orphan);
>> +		sbi->n_orphans--;
> 
> NAK.
> We should not release them here.
> Only f2fs_evict_inode can do it. 

Yeah, f2fs_evict_inode can do this job safely, sorry for my mistake,
please ignore this patch.:)

Regards,
Gu 

> 
>>  	}
>>  	if (!page)
>>  		goto end;
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3GWBJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:09:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3GWBJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:09:41 -0400
X-IronPort-AV: E=Sophos;i="4.89,722,1367942400"; 
   d="scan'208";a="7984565"
Message-ID: <51EDD6F9.7070207@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 09:06:01 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nikola Pajkovsky <npajkovs@redhat.com>
CC: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: use list_for_each rather than list_for_each_safe,
 in remove_orphan_inode()
References: <51E8F7A6.7030708@cn.fujitsu.com> <m3d2qa7gj6.fsf@redhat.com>
In-Reply-To: <m3d2qa7gj6.fsf@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:07:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:07:39,
	Serialize complete at 2013/07/23 09:07:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 11:36 PM, Nikola Pajkovsky wrote:

> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
> 
>> As we remove the target single node, so list_for_each is enought, in order to
>> clean up, we use list_for_each_entry instead.
>>
>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> ---
>>  fs/f2fs/checkpoint.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>> index 290db04..87f7bc2 100644
>> --- a/fs/f2fs/checkpoint.c
>> +++ b/fs/f2fs/checkpoint.c
>> @@ -237,13 +237,12 @@ out:
>>  
>>  void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>  {
>> -	struct list_head *this, *next, *head;
>> +	struct list_head *head;
>>  	struct orphan_inode_entry *orphan;
>>  
>>  	mutex_lock(&sbi->orphan_inode_mutex);
>>  	head = &sbi->orphan_inode_list;
>> -	list_for_each_safe(this, next, head) {
>> -		orphan = list_entry(this, struct orphan_inode_entry, list);
>> +	list_for_each_entry(orphan, head, list) {
>>  		if (orphan->ino == ino) {
>>  			list_del(&orphan->list);
>>  			kmem_cache_free(orphan_entry_slab, orphan);
> 
> you have meant list_for_each_entry_safe, haven't you?

No that, here list_for_each_entry is suitable, because we delete only one entry.

Thanks,
Gu  

> 



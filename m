Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab3GWHeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab3GWHef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:34:35 -0400
From: Nikola Pajkovsky <npajkovs@redhat.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Kim <jaegeuk.kim@samsung.com>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] f2fs: use list_for_each rather than list_for_each_safe, in remove_orphan_inode()
References: <51E8F7A6.7030708@cn.fujitsu.com> <m3d2qa7gj6.fsf@redhat.com>
	<51EDD6F9.7070207@cn.fujitsu.com>
Date: Tue, 23 Jul 2013 09:34:18 +0200
In-Reply-To: <51EDD6F9.7070207@cn.fujitsu.com> (Gu Zheng's message of "Tue, 23
	Jul 2013 09:06:01 +0800")
Message-ID: <m3ob9trapx.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu Zheng <guz.fnst@cn.fujitsu.com> writes:

> On 07/22/2013 11:36 PM, Nikola Pajkovsky wrote:
>
>> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
>> 
>>> As we remove the target single node, so list_for_each is enought, in order to
>>> clean up, we use list_for_each_entry instead.
>>>
>>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>> ---
>>>  fs/f2fs/checkpoint.c |    5 ++---
>>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
>>> index 290db04..87f7bc2 100644
>>> --- a/fs/f2fs/checkpoint.c
>>> +++ b/fs/f2fs/checkpoint.c
>>> @@ -237,13 +237,12 @@ out:
>>>  
>>>  void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>>>  {
>>> -	struct list_head *this, *next, *head;
>>> +	struct list_head *head;
>>>  	struct orphan_inode_entry *orphan;
>>>  
>>>  	mutex_lock(&sbi->orphan_inode_mutex);
>>>  	head = &sbi->orphan_inode_list;
>>> -	list_for_each_safe(this, next, head) {
>>> -		orphan = list_entry(this, struct orphan_inode_entry, list);
>>> +	list_for_each_entry(orphan, head, list) {
>>>  		if (orphan->ino == ino) {
>>>  			list_del(&orphan->list);
>>>  			kmem_cache_free(orphan_entry_slab, orphan);
>> 
>> you have meant list_for_each_entry_safe, haven't you?
>
> No that, here list_for_each_entry is suitable, because we delete only one entry.

yeah, you're correct.

-- 
Nikola

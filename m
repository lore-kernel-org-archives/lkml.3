Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab3HTLGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:06:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10879 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3HTLGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:06:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367942400"; 
   d="scan'208";a="8250605"
Message-ID: <52134D78.9020006@cn.fujitsu.com>
Date: Tue, 20 Aug 2013 19:05:28 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] page_migrate: Fix wrong comment in address_space_operations->migratepage()
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com> <1371723023-4060-3-git-send-email-tangchen@cn.fujitsu.com> <alpine.LNX.2.00.1308201302290.21654@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1308201302290.21654@pobox.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 19:05:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 19:05:02,
	Serialize complete at 2013/08/20 19:05:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 07:02 PM, Jiri Kosina wrote:
> On Thu, 20 Jun 2013, Tang Chen wrote:
>
>> There is no parameter "sync" in address_space_operations->migratepage().
>> It should be mograte_mode. And the comment is for MIGRATE_ASYNC.
>
> I am fixing this typo in changelog :) and applying the series.

Hi Jiri,

Thanks a lot. :)

>
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> ---
>>   include/linux/fs.h |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 43db02e..c1a76ac 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -372,8 +372,8 @@ struct address_space_operations {
>>   	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
>>   						void **, unsigned long *);
>>   	/*
>> -	 * migrate the contents of a page to the specified target. If sync
>> -	 * is false, it must not block.
>> +	 * migrate the contents of a page to the specified target. If
>> +	 * migrate_mode is MIGRATE_ASYNC, it must not block.
>>   	 */
>>   	int (*migratepage) (struct address_space *,
>>   			struct page *, struct page *, enum migrate_mode);
>> --
>> 1.7.1
>>
>

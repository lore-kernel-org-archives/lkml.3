Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3LSJ3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:29:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3LSJ3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:29:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384272000"; 
   d="scan'208";a="9290856"
Message-ID: <52B2BACA.80600@cn.fujitsu.com>
Date: Thu, 19 Dec 2013 17:22:18 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: jaegeuk.kim@samsung.com
CC: Chao Yu <chao2.yu@samsung.com>,
        "'fsdevel'" <linux-fsdevel@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into
 __bio_alloc
References: <52B17905.7040708@cn.fujitsu.com> <000a01cefc59$0a9b4580$1fd1d080$@samsung.com> <1387443585.2101.216.camel@kjgkr>
In-Reply-To: <1387443585.2101.216.camel@kjgkr>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:28:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:28:57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim, Yu,
Thanks for your review!

On 12/19/2013 04:59 PM, Jaegeuk Kim wrote:

> Hi Gu,
> 
> I agreed with Chao.
> It is more readable to use something like "is_read" instead of "rw".

Agree. I'll follow it.

Regards,
Gu

> Thanks,
> 
> 2013-12-19 (목), 09:23 +0800, Chao Yu:
>> Hi Gu,
>>
>>> -----Original Message-----
>>> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
>>> Sent: Wednesday, December 18, 2013 6:29 PM
>>> To: Kim
>>> Cc: fsdevel; linux-kernel; f2fs
>>> Subject: [f2fs-dev] [PATCH] f2fs: move all the bio initialization into __bio_alloc
>>>
>>> Move all the bio initialization into __bio_alloc, and some minor cleanups are
>>> also added.
>>
>> Looks more neat!
>>
>>> @@ -178,17 +179,16 @@ void f2fs_submit_page_mbio(struct f2fs_sb_info *sbi, struct page *page,
>>>  			block_t blk_addr, struct f2fs_io_info *fio)
>>>  {
>>>  	enum page_type btype = PAGE_TYPE_OF_BIO(fio->type);
>>> -	struct block_device *bdev = sbi->sb->s_bdev;
>>>  	struct f2fs_bio_info *io;
>>> -	int bio_blocks;
>>> +	int rw = is_read_io(fio->rw);
>>
>> Maybe it's more neat to use 'is_read' to instead of 'rw'.
>>
>> Thanks
>>
> 



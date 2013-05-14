Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3ENDSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:18:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3ENDSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:18:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,666,1363104000"; 
   d="scan'208";a="7261978"
Message-ID: <5191AC7B.3010701@cn.fujitsu.com>
Date: Tue, 14 May 2013 11:16:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()
References: <5190AAB9.5080904@cn.fujitsu.com> <87obcfqldw.fsf@devron.myhome.or.jp>
In-Reply-To: <87obcfqldw.fsf@devron.myhome.or.jp>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 11:17:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/14 11:17:14,
	Serialize complete at 2013/05/14 11:17:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 05:28 PM, OGAWA Hirofumi wrote:

> Gu Zheng <guz.fnst@cn.fujitsu.com> writes:
> 
>> >From 87141ec058aad35ac55bc7c3fc2eb378566a5a6a Mon Sep 17 00:00:00 2001
>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Date: Mon, 13 May 2013 17:48:19 +0900
>> Subject: [PATCH] fs/fat: Use fat_msg() to replace printk() in __fat_fs_error()
> 
>> -		printk(KERN_ERR "FAT-fs (%s): error, %pV\n", sb->s_id, &vaf);
>> +		fat_msg(sb, KERN_ERR, "error, %pV", &vaf);
>>  		va_end(args);
> 
> I'm assuming nested "%pV" is works fine. If so,

It works fine, I've tested this.

> 
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks!

Best regards,
Gu

> 
>> @@ -38,8 +38,7 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
>>  		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
>>  	else if (opts->errors == FAT_ERRORS_RO && !(sb->s_flags & MS_RDONLY)) {
>>  		sb->s_flags |= MS_RDONLY;
>> -		printk(KERN_ERR "FAT-fs (%s): Filesystem has been "
>> -				"set read-only\n", sb->s_id);
>> +		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
>>  	}
>>  }
>>  EXPORT_SYMBOL_GPL(__fat_fs_error);
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaKFDM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:12:59 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40153 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKFDM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:12:58 -0500
Message-ID: <545AE8AA.1030705@gmail.com>
Date: Thu, 06 Nov 2014 11:19:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] include/linux/audit.h: Move dummy audit_file() from !AUDIT
 area to !AUDITSYSCALL area
References: <5458EC40.5020807@gmail.com> <283051037.h5QtGpv3rn@sifl>
In-Reply-To: <283051037.h5QtGpv3rn@sifl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/14 4:43, Paul Moore wrote:
> On Tuesday, November 04, 2014 11:09:52 PM Chen Gang wrote:
>> audit_file() is related with AUDITSYSCALL, not related with AUDIT, so
>> need move dummy one from !AUDIT area to !AUDITSYSCALL area. Or it will
>> cause issue if CONFIG_AUDIT with !CONFIG_AUDITSYSCALL.
>>
>> The related error (with allmodconfig under tile):
>>
>>     CC      fs/open.o
>>   fs/open.c: In function 'SYSC_fchmod':
>>   fs/open.c:530:3: error: implicit declaration of function 'audit_file'
>> [-Werror=implicit-function-declaration] audit_file(f.file);
>>      ^
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  include/linux/audit.h | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> What version of the kernel source are you looking at?  I don't see the 
> audit_file() function anywhere ...
> 

It is for next tree. Sorry for not marking it in subject, originally.

Thanks.

>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>> index 295ae1c..7b1d0d1 100644
>> --- a/include/linux/audit.h
>> +++ b/include/linux/audit.h
>> @@ -363,6 +363,8 @@ static inline void audit_inode(struct filename *name,
>>  				const struct dentry *dentry,
>>  				unsigned int parent)
>>  { }
>> +static inline void audit_file(struct file *file)
>> +{ }
>>  static inline void audit_inode_parent_hidden(struct filename *name,
>>  				const struct dentry *dentry)
>>  { }
>> @@ -538,9 +540,6 @@ static inline void audit_log_task_info(struct
>> audit_buffer *ab, struct task_struct *tsk)
>>  { }
>>  #define audit_enabled 0
>> -static inline void audit_file(struct file *file)
>> -{
>> -}
>>  #endif /* CONFIG_AUDIT */
>>  static inline void audit_log_string(struct audit_buffer *ab, const char
>> *buf) {
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed

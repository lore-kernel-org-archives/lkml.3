Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964928Ab3E2HsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:48:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19530 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935105Ab3E2HsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:48:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,763,1363104000"; 
   d="scan'208";a="7399706"
Message-ID: <51A5B210.6020501@cn.fujitsu.com>
Date: Wed, 29 May 2013 15:45:20 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem obsolete
References: <51A1AC4A.60506@gmail.com> <51A1AD67.4030800@gmail.com> <87wqqi7n73.fsf@xmission.com>
In-Reply-To: <87wqqi7n73.fsf@xmission.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/29 15:46:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/29 15:46:30,
	Serialize complete at 2013/05/29 15:46:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 06:29 AM, Eric W. Biederman wrote:
> Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:
> 
>> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>>
>> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>> Cc: Dave Jones <davej@redhat.com>
>> ---
>>  Documentation/devices.txt |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
>> index 08f01e7..c8e4002 100644
>> --- a/Documentation/devices.txt
>> +++ b/Documentation/devices.txt
>> @@ -100,8 +100,7 @@ Your cooperation is appreciated.
>>  		 10 = /dev/aio		Asynchronous I/O notification interface
>>  		 11 = /dev/kmsg		Writes to this come out as printk's, reads
>>  					export the buffered printk records.
>> -		 12 = /dev/oldmem	Used by crashdump kernels to access
>> -					the memory of the kernel that crashed.
>> +		 12 = /dev/oldmem	OBSOLETE
> 
> Let me suggest the slightly better.
> 
>  +		12 = /dev/oldmem	OBSOLETE - replaced by /proc/vmcore
> 
> Pointing to people to /proc/vmcore should help anyone who is trying to
> understand what is going on.

Makes sense to me. Updated patch below:

-----------------------------------
>From d2f7baf2aba86069f941f32669a22dbd99082614 Mon Sep 17 00:00:00 2001
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Wed, 29 May 2013 15:44:09 +0800
Subject: [PATCH] Documentation/devices.txt: Mark /dev/oldmem obsolete

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/devices.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 08f01e7..315455a 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -100,8 +100,7 @@ Your cooperation is appreciated.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's, reads
 					export the buffered printk records.
-		 12 = /dev/oldmem	Used by crashdump kernels to access
-					the memory of the kernel that crashed.
+		 12 = /dev/oldmem	OBSOLETE - replaced by /proc/vmcore
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
-- 
1.7.1


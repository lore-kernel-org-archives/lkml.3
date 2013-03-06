Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3CFJPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 04:15:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43062 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFJPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 04:15:01 -0500
Date: Wed, 06 Mar 2013 18:14:57 +0900 (JST)
Message-Id: <20130306.181457.101447189.d.hatayama@jp.fujitsu.com>
To: zhangyanfei@cn.fujitsu.com
Cc: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/20] vmcore: allocate buffer for ELF headers on
 page-size alignment
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <5136E8EE.6080301@cn.fujitsu.com>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
	<20130302083610.31252.18601.stgit@localhost6.localdomain6>
	<5136E8EE.6080301@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 04/20] vmcore: allocate buffer for ELF headers on page-size alignment
Date: Wed, 6 Mar 2013 14:57:50 +0800

> 于 2013年03月02日 16:36, HATAYAMA Daisuke 写道:
>> Allocate buffer for ELF headers on page-size aligned boudary to
>> satisfy mmap() requirement. For this, __get_free_pages() is used
>> instead of kmalloc().
>> 
>> Also, later patch will decrease actually used buffer size for ELF
>> headers, so it's necessary to keep original buffer size and actually
>> used buffer size separately. elfcorebuf_sz_orig keeps the original one
>> and elfcorebuf_sz the actually used one.
>> 
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>> 
>>  fs/proc/vmcore.c |   30 +++++++++++++++++++++---------
>>  1 files changed, 21 insertions(+), 9 deletions(-)
>> 

....

>> @@ -665,26 +671,31 @@ static int __init parse_crash_elf32_headers(void)
>>  
>>  	/* Read in all elf headers. */
>>  	elfcorebuf_sz = ehdr.e_phoff + ehdr.e_phnum * sizeof(Elf32_Phdr);
>> -	elfcorebuf = kmalloc(elfcorebuf_sz, GFP_KERNEL);
>> +	elfcorebuf_sz_orig = elfcorebuf_sz;
>> +	elfcorebuf = (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
>> +					       get_order(elfcorebuf_sz));
> 
> Why not elfcorebuf_sz_orig here?
> 

Thanks. I'll fix this.

Thanks.
HATAYAMA, Daisuke


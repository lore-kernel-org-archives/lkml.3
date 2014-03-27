Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaC0Cbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:31:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:9562 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaC0Cbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:31:42 -0400
Message-ID: <53338CFE.3060705@huawei.com>
Date: Thu, 27 Mar 2014 10:29:18 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/3] kmemleak: allow freeing internal objects after
 kmemleak was disabled
References: <5326750E.1000004@huawei.com> <F7314A69-24BE-42B9-8E99-8F9292B397C4@arm.com>
In-Reply-To: <F7314A69-24BE-42B9-8E99-8F9292B397C4@arm.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Just came back from travelling)

On 2014/3/22 7:37, Catalin Marinas wrote:
> Hi Li,
> 
> On 17 Mar 2014, at 04:07, Li Zefan <lizefan@huawei.com> wrote:
>> Currently if kmemleak is disabled, the kmemleak objects can never be freed,
>> no matter if it's disabled by a user or due to fatal errors.
>>
>> Those objects can be a big waste of memory.
>>
>>  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>> 1200264 1197433  99%    0.30K  46164       26    369312K kmemleak_object
>>
>> With this patch, internal objects will be freed immediately if kmemleak is
>> disabled explicitly by a user. If it's disabled due to a kmemleak error,
>> The user will be informed, and then he/she can reclaim memory with:
>>
>> 	# echo off > /sys/kernel/debug/kmemleak
>>
>> v2: use "off" handler instead of "clear" handler to do this, suggested
>>    by Catalin.
> 
> I think there was a slight misunderstanding. My point was about "echo
> scan=off¡± before ¡°echo off¡±, they can just be squashed into the
> same action of the latter.
> 

I'm not sure if I understand correctly, so you want the "off" handler to
stop the scan thread but it will never free kmemleak objects until the 
user explicitly trigger the "clear" action, right?

> I would keep the ¡°clear¡± part separately as per your first patch. I
> recall people asked in the past to still be able to analyse the reports
> even though kmemleak failed or was disabled.
> 


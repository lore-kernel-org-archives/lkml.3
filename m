Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3EQP2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 11:28:30 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38800 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3EQP22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 11:28:28 -0400
Message-ID: <51964C95.2010401@gmail.com>
Date: Fri, 17 May 2013 23:28:21 +0800
From: Liu Jiang <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH v6, part3 16/16] AVR32: fix building warnings caused by
 redifinitions of HZ
References: <1368293689-16410-17-git-send-email-jiang.liu@huawei.com> <1368293689-16410-1-git-send-email-jiang.liu@huawei.com> <15932.1368438005@warthog.procyon.org.uk>
In-Reply-To: <15932.1368438005@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 05:40 PM, David Howells wrote:
> Jiang Liu <liuj97@gmail.com> wrote:
>
>> -#ifndef HZ
>> +#ifndef __KERNEL__
>> +   /*
>> +    * Technically, this is wrong, but some old apps still refer to it.
>> +    * The proper way to get the HZ value is via sysconf(_SC_CLK_TCK).
>> +    */
>>   # define HZ		100
>>   #endif
> Better still, use asm-generic/param.h and uapi/asm-generic/param.h for AVR32
> instead.
>
> David
>
Hi David,
         Great idea! Will use generic param.h for AVR32.
Regards!
Gerry

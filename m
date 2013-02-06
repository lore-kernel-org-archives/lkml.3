Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab3BFCVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:21:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64967 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab3BFCVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:21:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,612,1355068800"; 
   d="scan'208";a="6693636"
Message-ID: <5111BE09.2030509@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 10:20:57 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] acpi, memory-hotplug: Support getting hotplug info
 from SRAT.
References: <1359106929-3034-1-git-send-email-tangchen@cn.fujitsu.com> <1359106929-3034-4-git-send-email-tangchen@cn.fujitsu.com> <20130204152651.2bca8dba.akpm@linux-foundation.org>
In-Reply-To: <20130204152651.2bca8dba.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 10:20:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 10:20:24,
	Serialize complete at 2013/02/06 10:20:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 07:26 AM, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:42:09 +0800
> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>
>> We now provide an option for users who don't want to specify physical
>> memory address in kernel commandline.
>>
>>          /*
>>           * For movablemem_map=acpi:
>>           *
>>           * SRAT:                |_____| |_____| |_________| |_________| ......
>>           * node id:                0       1         1           2
>>           * hotpluggable:           n       y         y           n
>>           * movablemem_map:              |_____| |_________|
>>           *
>>           * Using movablemem_map, we can prevent memblock from allocating memory
>>           * on ZONE_MOVABLE at boot time.
>>           */
>>
>> So user just specify movablemem_map=acpi, and the kernel will use hotpluggable
>> info in SRAT to determine which memory ranges should be set as ZONE_MOVABLE.
>>
>> ...
>>
>> +	if (!strncmp(p, "acpi", max(4, strlen(p))))
>> +		movablemem_map.acpi = true;
>
> Generates a warning:
>
> mm/page_alloc.c: In function 'cmdline_parse_movablemem_map':
> mm/page_alloc.c:5312: warning: comparison of distinct pointer types lacks a cast
>
> due to max(int, size_t).
>
> This is easily fixed, but the code looks rather pointless.  If the
> incoming string is supposed to be exactly "acpi" then use strcmp().  If
> the incoming string must start with "acpi" then use strncmp(p, "acpi", 4).
>
> IOW, the max is unneeded?

Hi Andrew,

I think I made another mistake here. I meant to use min(4, strlen(p)) in 
case p is
something like 'aaa' whose length is less then 4. But I mistook it with 
max().

But after I dig into strcmp() in the kernel, I think it is OK to use 
strcmp().
min() or max() is not needed.

Thanks. :)

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

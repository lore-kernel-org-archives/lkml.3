Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3HENjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:39:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3HENjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:39:52 -0400
X-IronPort-AV: E=Sophos;i="4.89,818,1367942400"; 
   d="scan'208";a="8123219"
Message-ID: <51FFAAD1.9040405@cn.fujitsu.com>
Date: Mon, 05 Aug 2013 21:38:25 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 00/18] Arrange hotpluggable memory as ZONE_MOVABLE.
References: <1375340800-19332-1-git-send-email-tangchen@cn.fujitsu.com> <51FFA393.2080301@zytor.com>
In-Reply-To: <51FFA393.2080301@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 21:38:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/05 21:38:30,
	Serialize complete at 2013/08/05 21:38:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi hpa,

I'm sorry but I don't quite following it.

On 08/05/2013 09:07 PM, H. Peter Anvin wrote:
> On 08/01/2013 12:06 AM, Tang Chen wrote:
>> This patch-set aims to solve some problems at system boot time
>> to enhance memory hotplug functionality.
>>
>> [Background]
>>
>> The Linux kernel cannot migrate pages used by the kernel because
>> of the kernel direct mapping. Since va = pa + PAGE_OFFSET, if the
>> physical address is changed, we cannot simply update the kernel
>> pagetable. On the contrary, we have to update all the pointers
>> pointing to the virtual address, which is very difficult to do.
>>
>
> It does beg the question if that "since" statement should be changed ...

Do you mean we are going to do kernel page migration in the future ?

> we already have it handled differently on Xen PV, but that is kind of
> "special".  There are a whole bunch of other issues with moving kernel
> memory around: you have to worry what might have a physical address
> cached somewhere and what might be in active use and so on...

The current solution is to hotplug ZONE_MOVABLE, which the kernel won't
use. So do you mean if I want to do kernel page migration (which I'm not
doing), I need to worry about what you said above ?

>I am not
> really suggesting it as anything but food for thought at this time.

Sorry for my poor English, and I really cannot understand this one.

Thanks.

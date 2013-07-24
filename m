Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab3GXCue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 22:50:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab3GXCub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 22:50:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,732,1367942400"; 
   d="scan'208";a="7999819"
Message-ID: <51EF4196.8050303@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 10:53:10 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 02/21] memblock, numa: Introduce flag into memblock.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-3-git-send-email-tangchen@cn.fujitsu.com> <20130723190928.GH21100@mtj.dyndns.org>
In-Reply-To: <20130723190928.GH21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 10:48:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 10:48:28,
	Serialize complete at 2013/07/24 10:48:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 03:09 AM, Tejun Heo wrote:
> Hello,
>
> On Fri, Jul 19, 2013 at 03:59:15PM +0800, Tang Chen wrote:
>> +#define MEMBLK_FLAGS_DEFAULT	0x0	/* default flag */
>
> Please don't do this.  Just clearing the struct as zero is enough.
>
>> @@ -439,12 +449,14 @@ repeat:
>>   int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
>>   				       int nid)
>>   {
>> -	return memblock_add_region(&memblock.memory, base, size, nid);
>> +	return memblock_add_region(&memblock.memory, base, size,
>> +				   nid, MEMBLK_FLAGS_DEFAULT);
>
> And just use zero for no flag.  Doing something like the above gets
> weird with actual flags.  e.g. if you add a flag, say, MEMBLK_HOTPLUG,
> should it be MEMBLK_FLAGS_DEFAULT | MEMBLK_HOTPLUG or just
> MEMBLK_HOTPLUG?  If latter, the knowledge that DEFAULT is zero is
> implicit, and, if so, why do it at all?

OK, will remove MEMBLK_FLAGS_DEFAULT, and use 0 by default.

>
>> +static int __init_memblock memblock_reserve_region(phys_addr_t base,
>> +						   phys_addr_t size,
>> +						   int nid,
>> +						   unsigned long flags)
>>   {
>>   	struct memblock_type *_rgn =&memblock.reserved;
>>
>> -	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
>> +	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] with flags %#016lx %pF\n",
>
> Let's please drop "with" and do we really need to print full 16
> digits?

Sure, will remove "with". But I think printing out the full flags is batter.
The output seems more tidy.


Thanks.

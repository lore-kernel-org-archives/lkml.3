Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3GYCcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:32:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28100 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab3GYCcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:32:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,739,1367942400"; 
   d="scan'208";a="8014378"
Message-ID: <51F08ED0.9080407@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 10:34:56 +0800
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
Subject: Re: [PATCH 15/21] x86, acpi, numa: Don't reserve memory on nodes
 the kernel resides in.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-16-git-send-email-tangchen@cn.fujitsu.com> <20130723205919.GT21100@mtj.dyndns.org>
In-Reply-To: <20130723205919.GT21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 10:30:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 10:30:08,
	Serialize complete at 2013/07/25 10:30:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 04:59 AM, Tejun Heo wrote:
......
>> +static bool __init kernel_resides_in_range(phys_addr_t base, u64 length)
>> +{
>> +	int i;
>> +	struct memblock_type *reserved =&memblock.reserved;
>> +	struct memblock_region *region;
>> +	phys_addr_t start, end;
>> +
>> +	for (i = 0; i<  reserved->cnt; i++) {
>> +		region =&reserved->regions[i];
>> +
>> +		if (region->flags != MEMBLK_FLAGS_DEFAULT)
>> +			continue;
>> +
>> +		start = region->base;
>> +		end = region->base + region->size;
>> +		if (end<= base || start>= base + length)
>> +			continue;
>> +
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>
> This being in acpi/osl.c is rather weird.  Overall, the acpi and
> memblock parts don't seem very well split.  It'd best if acpi just
> indicates which regions are hotpluggable and the rest is handled by
> x86 boot or memblock code as appropriate.

OK. Will move this function out from acpi side.

Thanks.


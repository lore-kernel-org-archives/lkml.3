Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3HWRad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:30:33 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35757 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3HWRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:30:31 -0400
Message-ID: <52179C14.20407@gmail.com>
Date: Sat, 24 Aug 2013 01:29:56 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Tejun Heo <tj@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
References: <20130822033234.GA2413@htj.dyndns.org>  <1377186729.10300.643.camel@misato.fc.hp.com>  <20130822183130.GA3490@mtj.dyndns.org>  <1377202292.10300.693.camel@misato.fc.hp.com>  <20130822202158.GD3490@mtj.dyndns.org>  <1377205598.10300.715.camel@misato.fc.hp.com>  <20130822212111.GF3490@mtj.dyndns.org>  <1377209861.10300.756.camel@misato.fc.hp.com>  <20130823130440.GC10322@mtj.dyndns.org>  <1377274448.10300.777.camel@misato.fc.hp.com>  <20130823162444.GL3277@htj.dyndns.org> <1377278016.10300.814.camel@misato.fc.hp.com>
In-Reply-To: <1377278016.10300.814.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

On 08/24/2013 01:13 AM, Toshi Kani wrote:
> Hello,
> 
> On Fri, 2013-08-23 at 12:24 -0400, Tejun Heo wrote:
>> On Fri, Aug 23, 2013 at 10:14:08AM -0600, Toshi Kani wrote:
>>> I still think acpi table info should be available earlier, but I do not
>>> think I can convince you on this.  This can be religious debate.
>>
>> I'm curious.  If there aren't substantial enough benefits, why would
>> you still want to pull it earlier when it brings in things like initrd
>> override and crafting the code carefully so that it's safe to execute
>> it from different address modes and so on?  Please note that x86 is
>> not ia64.  The early environment is completely different not only
>> technically but also in its diversity and suckiness.  It wasn't too
>> long ago that vendors were screwing up ACPI left and right.  It has
>> been getting better but there's a reason why, for example, we still
>> consider e820 to be the authoritative information over ACPI.
> 
> Firmware generates tables, and provides them via some interface.  Memory
> map table can be provided via e820 or EFI memory map.  Memory topology
> table is provided via ACPI.  I agree to prioritize one table over the
> other when there is overlap.  But in the end, it is the firmware that
> generates the tables.  Because it is provided via ACPI does not make it
> suddenly unreliable.  I think table info from e820/EFI/ACPI should be
> available at the same time.  To me, it makes more sense to use the
> hotplug info to initialize memblock than try to find a way to workaround
> without it.  

Yeah, agreed. But sigh.... on x86, we have ACPI initrd override, so we still
cannot convince Tj....

I think we will continue to be in that way to find a
> workaround in this direction. 
> 
> I came from ia64 background, and am not very familiar with x86.  So, you
> may be very right about that x86 is different.  I also agree that initrd
> is making it unnecessarily complicated.  We may see some initial issues,
> but my hope is that the code gets matured over the time.
> 
> Thanks,
> -Toshi
> 


-- 
Thanks.
Zhang Yanfei

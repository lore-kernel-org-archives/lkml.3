Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3IXNfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:35:20 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38704 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3IXNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:35:15 -0400
Message-ID: <524194F6.4000101@gmail.com>
Date: Tue, 24 Sep 2013 21:34:46 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com,
        "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com
Subject: Re: [PATCH 4/6] x86/mem-hotplug: Support initialize page tables bottom
 up
References: <524162DA.30004@cn.fujitsu.com> <5241649B.3090302@cn.fujitsu.com> <20130924123340.GE2366@htj.dyndns.org> <52419264.3020409@gmail.com> <20130924132727.GI2366@htj.dyndns.org>
In-Reply-To: <20130924132727.GI2366@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 09:27 PM, Tejun Heo wrote:
> On Tue, Sep 24, 2013 at 09:23:48PM +0800, Zhang Yanfei wrote:
>>> Hmm... so, this is kinda weird.  We're doing it in two chunks and
>>> mapping memory between ISA_END_ADDRESS and kernel_end right on top of
>>> ISA_END_ADDRESS?  Can't you give enough information to the mapping
>>> function so that it can map everything on top of kernel_end in single
>>> go?
>>
>> You mean we should call memory_map_bottom_up like this:
>>
>> memory_map_bottom_up(ISA_END_ADDRESS, end)
>>
>> right?
> 
> But that wouldn't be ideal as we want the page tables above kernel
> image and the above would allocate it above ISA_END_ADDRESS, right?

The original idea is we will allocate everything above the kernel. So
the pagetables for [ISA_END_ADDRESS, kernel_end) will be also located
above the kernel.

> Maybe memory_map_bottom_up() should take extra parameters for where to
> allocate page tables at separately from the mapping range and treat it
> specially?  Would that make the function a lot more complex?

Hmmmm...I will try to see if it is complex.

Thanks.

> 
> Thanks.
> 


-- 
Thanks.
Zhang Yanfei

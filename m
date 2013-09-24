Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3IXOQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:16:47 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:46396 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3IXOQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:16:45 -0400
Date: Tue, 24 Sep 2013 10:16:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
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
Subject: Re: [PATCH 2/6] memblock: Introduce bottom-up allocation mode
Message-ID: <20130924141640.GK2366@htj.dyndns.org>
References: <524162DA.30004@cn.fujitsu.com>
 <524163CF.3010303@cn.fujitsu.com>
 <20130924121725.GC2366@htj.dyndns.org>
 <524190DC.4060605@gmail.com>
 <20130924132327.GH2366@htj.dyndns.org>
 <52419DC6.4030800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52419DC6.4030800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 10:12:22PM +0800, Zhang Yanfei wrote:
> I see. I think it is rarely to fail. But here is case that it must
> fail in the current bottom-up implementation. For example, we allocate
> memory in reserve_real_mode() by calling this: 
> memblock_find_in_range(0, 1<<20, size, PAGE_SIZE);
> 
> Both the start and end is below the kernel, so trying bottom-up for
> this must fail. So I am now thinking that if we should take this as
> the special case for bottom-up. That said, if we limit start and end
> both below the kernel, we should allocate memory below the kernel instead
> of make it fail. The cases are also rare, in early boot time, only
> these two:
> 
>  |->early_reserve_e820_mpc_new()   /* allocate memory under 1MB */
>  |->reserve_real_mode()            /* allocate memory under 1MB */
> 
> How do you think?

They need to be special cased regardless, right?  It's wrong to print
out warning messages for things which are expected to behave that way.
Just skip bottom-up allocs if @end is under kernel image?

Thanks.

-- 
tejun

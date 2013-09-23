Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3IWUV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:21:59 -0400
Received: from mail-ye0-f177.google.com ([209.85.213.177]:48786 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab3IWUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:21:55 -0400
X-Greylist: delayed 11433 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 16:21:55 EDT
Date: Mon, 23 Sep 2013 16:21:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, toshi.kani@hp.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 2/5] memblock: Improve memblock to support allocation
 from lower address.
Message-ID: <20130923202147.GB28667@mtj.dyndns.org>
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>
 <1379064655-20874-3-git-send-email-tangchen@cn.fujitsu.com>
 <20130923155027.GD14547@htj.dyndns.org>
 <52408351.8080400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52408351.8080400@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 02:07:13AM +0800, Zhang Yanfei wrote:
> Yes, I am following your advice in principle but kind of confused by
> something you said above. Where should the set_memblock_alloc_above_kernel
> be used? IMO, the function is like:
> 
> find_in_range_node()
> {
>      if (ok) {
>            /* bottom-up */
>            ret = __memblock_find_in_range(max(start, _end_of_kernel), end...);
>            if (!ret)
>                  return ret;
>      }
> 
>      /* top-down retry */
>      return __memblock_find_in_range_rev(start, end...)
> }
> 
> For bottom-up allocation, we always start from max(start, _end_of_kernel).

Oh, I was talking about naming of the memblock_set_bottom_up()
function.  We aren't really doing pure bottom up allocations, so I
think it probably would be clearer if the name clearly denotes that
we're doing above-kernel allocation.

Thanks.

-- 
tejun

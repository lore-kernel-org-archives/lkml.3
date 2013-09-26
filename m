Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IZPuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:50:24 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:44166 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3IZPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:50:20 -0400
Date: Thu, 26 Sep 2013 11:50:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
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
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 2/6] memblock: Introduce bottom-up allocation mode
Message-ID: <20130926155015.GB32391@mtj.dyndns.org>
References: <5241D897.1090905@gmail.com>
 <5241D9A4.4080305@gmail.com>
 <20130926144516.GD3482@htj.dyndns.org>
 <524454BE.4030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524454BE.4030602@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 11:37:34PM +0800, Zhang Yanfei wrote:
> >> +		WARN_ONCE(1, "memblock: Failed to allocate memory in bottom up "
> >> +			"direction. Now try top down direction.\n");
> >> +	}
> > 
> > You and I would know what was going on and what the consequence of the
> > failure may be but the above warning message is kinda useless to a
> > user / admin, right?  It doesn't really say anything meaningful.
> > 
> 
> Hmmmm.. May be something like this:
> 
> WARN_ONCE(1, "Failed to allocated memory above the kernel in bottom-up,"
>           "so try to allocate memory below the kernel.");

How about something like "memblock: bottom-up allocation failed,
memory hotunplug may be affected\n".

Thanks.

-- 
tejun

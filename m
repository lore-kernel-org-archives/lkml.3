Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994Ab3GWTJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:09:38 -0400
Received: from mail-ye0-f178.google.com ([209.85.213.178]:56884 "EHLO
	mail-ye0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab3GWTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:09:35 -0400
Date: Tue, 23 Jul 2013 15:09:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Message-ID: <20130723190928.GH21100@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-3-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374220774-29974-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 19, 2013 at 03:59:15PM +0800, Tang Chen wrote:
> +#define MEMBLK_FLAGS_DEFAULT	0x0	/* default flag */

Please don't do this.  Just clearing the struct as zero is enough.

> @@ -439,12 +449,14 @@ repeat:
>  int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
>  				       int nid)
>  {
> -	return memblock_add_region(&memblock.memory, base, size, nid);
> +	return memblock_add_region(&memblock.memory, base, size,
> +				   nid, MEMBLK_FLAGS_DEFAULT);

And just use zero for no flag.  Doing something like the above gets
weird with actual flags.  e.g. if you add a flag, say, MEMBLK_HOTPLUG,
should it be MEMBLK_FLAGS_DEFAULT | MEMBLK_HOTPLUG or just
MEMBLK_HOTPLUG?  If latter, the knowledge that DEFAULT is zero is
implicit, and, if so, why do it at all?

> +static int __init_memblock memblock_reserve_region(phys_addr_t base,
> +						   phys_addr_t size,
> +						   int nid,
> +						   unsigned long flags)
>  {
>  	struct memblock_type *_rgn = &memblock.reserved;
>  
> -	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] %pF\n",
> +	memblock_dbg("memblock_reserve: [%#016llx-%#016llx] with flags %#016lx %pF\n",

Let's please drop "with" and do we really need to print full 16
digits?

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3IWP5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:57:21 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:32993 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3IWP5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:57:19 -0400
Date: Mon, 23 Sep 2013 11:57:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, toshi.kani@hp.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 5/5] mem-hotplug: Introduce movablenode boot option to
 control memblock allocation direction.
Message-ID: <20130923155713.GF14547@htj.dyndns.org>
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>
 <1379064655-20874-6-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379064655-20874-6-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 13, 2013 at 05:30:55PM +0800, Tang Chen wrote:
> +#ifdef CONFIG_MOVABLE_NODE
> +	if (movablenode_enable_srat) {
> +		/*
> +		 * When ACPI SRAT is parsed, which is done in initmem_init(),
> +		 * set memblock back to the default behavior.
> +		 */
> +		memblock_set_current_direction(MEMBLOCK_DIRECTION_DEFAULT);
> +	}
> +#endif /* CONFIG_MOVABLE_NODE */

It's kinda weird to have ifdef around the above when all the actual
code would be compiled and linked regardless of the above ifdef.
Wouldn't it make more sense to conditionalize
memblock_direction_bottom_up() so that it's constant false to allow
the compiler to drop unnecessary code?

Thanks.

-- 
tejun

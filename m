Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3IWRLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:11:24 -0400
Received: from mail-yh0-f68.google.com ([209.85.213.68]:55870 "EHLO
	mail-yh0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3IWRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:11:22 -0400
Date: Mon, 23 Sep 2013 13:11:08 -0400
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
Subject: Re: [PATCH v3 5/5] mem-hotplug: Introduce movablenode boot option to
 control memblock allocation direction.
Message-ID: <20130923171108.GG14547@htj.dyndns.org>
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com>
 <1379064655-20874-6-git-send-email-tangchen@cn.fujitsu.com>
 <20130923155713.GF14547@htj.dyndns.org>
 <5240731B.9070906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240731B.9070906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 24, 2013 at 12:58:03AM +0800, Zhang Yanfei wrote:
> you mean we define memblock_set_bottom_up and memblock_bottom_up like below:
> 
> #ifdef CONFIG_MOVABLE_NODE
> void memblock_set_bottom_up(bool enable)
> {
>         /* do something */
> }
> 
> bool memblock_bottom_up()
> {
>         return  direction == bottom_up;
> }
> #else
> void memblock_set_bottom_up(bool enable)
> {
>         /* empty */
> }
> 
> bool memblock_bottom_up()
> {
>         return false;
> }
> #endif
> 
> right?

Yeah, the compiler would be able to drop bottom_up code if
!MOVABLE_NODE as long as the implementation functions are static.

Thanks.

-- 
tejun

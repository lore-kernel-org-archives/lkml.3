Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3FRAxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:53:20 -0400
Received: from mail-ye0-f177.google.com ([209.85.213.177]:37972 "EHLO
	mail-ye0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3FRAxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:53:19 -0400
X-Greylist: delayed 3659 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 20:53:19 EDT
Date: Mon, 17 Jun 2013 17:53:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Part1 PATCH v5 10/22] x86, mm, numa: Move two functions calling
 on successful path later
Message-ID: <20130618005311.GT32663@mtj.dyndns.org>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128589-8953-11-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128589-8953-11-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Does the subject match the patch content?  What two functions?  The
patch is separating out the actual registration part so that the
discovery part can happen earlier, right?

> Currently, parsing numa info needs to allocate some buffer and need to be
> called after init_mem_mapping. So try to split parsing numa info procedure
> into two steps:
> 	- The first step will be called before init_mem_mapping, and it
> 	  should not need allocate buffers.

Document the requirement somewhere in the source code?

> 	- The second step will cantain all the buffer related code and be
> 	  executed later.
> 
> At last we will have early_initmem_init() and initmem_init().

Do you mean "eventually" or "in the end" by "at last"?

> This patch implements only the first step.
> 
> setup_node_data() and numa_init_array() are only called for successful
> path, so we can move these two callings to x86_numa_init(). That will also
> make numa_init() smaller and more readable.

I find the description somewhat difficult to follow.  :(

> -v2: remove online_node_map clear in numa_init(), as it is only
>      set in setup_node_data() at last in successful path.

I don't get this.  What prevents specific numa init functions (numaq,
x86_acpi, amd...) from updating node_online_map?

Thanks.

-- 
tejun

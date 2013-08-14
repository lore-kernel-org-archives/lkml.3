Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab3HNVgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:36:45 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:46697 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012Ab3HNVgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:36:42 -0400
Date: Wed, 14 Aug 2013 17:36:37 -0400
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Tang Chen <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
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
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130814213637.GO28628@htj.dyndns.org>
References: <20130812162247.GM15892@htj.dyndns.org>
 <520914D5.7080501@gmail.com>
 <20130812180758.GA8288@mtj.dyndns.org>
 <520BC950.1030806@gmail.com>
 <20130814182342.GG28628@htj.dyndns.org>
 <520BDD2F.2060909@gmail.com>
 <20130814195541.GH28628@htj.dyndns.org>
 <520BE891.8090004@gmail.com>
 <20130814203538.GK28628@htj.dyndns.org>
 <520BF3E3.5030006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BF3E3.5030006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 05:17:23PM -0400, KOSAKI Motohiro wrote:
> You haven't explain practical benefit of your opinion. As far as users have
> no benefit, I'm never agree. Sorry.

Umm... how about being more robust and actually useable to begin with?
What's the benefit of panicking?  Are you seriously saying that the
admin / boot script can use the kernel boot param to tell the kernel
to enable hotplug but can't check what nodes are hot unpluggable
afterwards?  The admin *needs* to check which nodes are hotpluggable
no matter how this part is handled.  How else is it gonna know which
nodes are hotpluggable?  Magic?

There's no such rule as kernel param should make the kernel panic if
it's not happy, so please take that out of your brain.  It of course
should be clear what the result of the kernel parameter is and
panicking is the crudest way to do that which is good enough or even
desriable in *some* cases.  It is not the required behavior by any
stretch of imgination, especially when the result of the parameter may
change due to changing circumstances.  That's an outright idiotic
thing to do.

-- 
tejun

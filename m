Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab3GYPJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:09:24 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:48724 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3GYPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:09:21 -0400
X-Greylist: delayed 151796 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jul 2013 11:09:21 EDT
Date: Thu, 25 Jul 2013 11:09:13 -0400
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
Subject: Re: [PATCH 17/21] page_alloc, mem-hotplug: Improve movablecore to
 {en|dis}able using SRAT.
Message-ID: <20130725150913.GD26107@mtj.dyndns.org>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
 <1374220774-29974-18-git-send-email-tangchen@cn.fujitsu.com>
 <20130723210435.GV21100@mtj.dyndns.org>
 <20130723211119.GW21100@mtj.dyndns.org>
 <51F0A074.403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0A074.403@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tang.

On Thu, Jul 25, 2013 at 11:50:12AM +0800, Tang Chen wrote:
> movablecore boot option was used to specify the size of ZONE_MOVABLE. And
> this patch-set aims to arrange ZONE_MOVABLE with SRAT info. So my original
> thinking is to reuse movablecore.
> 
> Since you said above, I think we have two problems here:
> 1. Should not let users care about where the hotplug info comes from.
> 2. Should not distinguish movable node and memory hotplug, since for now,
>    to use memory hotplug is to use movable node.
> 
> So how about something like "movablenode", just like "quiet" boot option.
> If users specify "movablenode", then memblock will reserve hotpluggable
> memory, and create movable nodes if any. If users specify nothing, then
> the kernel acts as before.

Maybe I'm confused but memory hotplug isn't likely to work without
this, right?  If so, wouldn't it make more sense to have
"memory_hotplug" option rather than "movablecore=acpi" which in no way
indicates that it has something to do with memory hotplug?

Thanks.

-- 
tejun

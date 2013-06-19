Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3FSGMC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:12:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16006 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab3FSGMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:12:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,894,1363104000"; 
   d="scan'208";a="7599188"
Message-ID: <51C14C5E.6090501@cn.fujitsu.com>
Date: Wed, 19 Jun 2013 14:14:54 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Part2 PATCH v4 08/15] x86, numa: Save nid when reserve memory
 into memblock.reserved[].
References: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com> <1371128619-8987-9-git-send-email-tangchen@cn.fujitsu.com> <20130618165753.GB4553@dhcp-192-168-178-175.profitbricks.localdomain>
In-Reply-To: <20130618165753.GB4553@dhcp-192-168-178-175.profitbricks.localdomain>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 14:10:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 14:10:55,
	Serialize complete at 2013/06/19 14:10:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasilis,

Thanks for reviewing. :)

On 06/19/2013 12:57 AM, Vasilis Liaskovitis wrote:
......
>
> However, patches 21,22 of part1 and all part3 patches increase kernel usage
> of local node memory by putting pagetables local to those nodes. Are these
> pagetable pages accounted in part2's memblock_kernel_nodemask? It looks like

No, they are not. What I wanted to acheve was that the local pagetable pages
are transparent to users. For a movable node (all memory is hotpluggable),
seeing from users level, they think all the node's memory is not used by 
the
kernel. Actually pagetable pages are used by the kernel, but users don't 
know
it, and they don't care about it.

And also, memblock_kernel_nodemask is only used at very early time. When 
the
system is up, it is useless.

This is just my approach for this problem. It is not good enough, and we can
improve it.

> part1 and part3 of these patchsets contradict or make the goal of part2 more
> difficult to achieve. (I will send more comments for part3 separately).
>

I think allocating pagetable to local node really makes thing a little more
difficult than before. But I also think Yinghai's work is reasonable 
because
it helps to improve the performance.

What I am thinking now is to allocate things like pagetable pages to local
device. (Seems I mentioned this before.)

If a node has more than one memory device, and all the pagetable pages are
allocated in one device. Then this device cannot be hot-removed unless all
the other memory devices are hot-removed.

So I think allocating pagetable pages to local device is more reasonable.
But as you said, this could be more complex.

Thanks. :)

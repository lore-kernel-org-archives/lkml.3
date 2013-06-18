Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab3FRQ6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:58:01 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55792 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127Ab3FRQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:57:59 -0400
Date: Tue, 18 Jun 2013 18:57:54 +0200
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [Part2 PATCH v4 08/15] x86, numa: Save nid when reserve memory
 into memblock.reserved[].
Message-ID: <20130618165753.GB4553@dhcp-192-168-178-175.profitbricks.localdomain>
References: <1371128619-8987-1-git-send-email-tangchen@cn.fujitsu.com>
 <1371128619-8987-9-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371128619-8987-9-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tang,

On Thu, Jun 13, 2013 at 09:03:32PM +0800, Tang Chen wrote:
> Since we introduced numa_sync_memblock_nid synchronize nid info in
> memblock.reserved[] and numa_meminfo, when numa_meminfo has been
> initialized, we need to save the nid into memblock.reserved[] when
> we reserve memory.

thanks for the updated patches.
I tested linux-next next-20130706 +part1+part2+part3 in a VM, hot-plugging
memory and rebooting with movablecore=acpi. I think with this patch and 9/15
we get the correct nids and the expected behaviour for the "movablecore=acpi"
option.

However, patches 21,22 of part1 and all part3 patches increase kernel usage
of local node memory by putting pagetables local to those nodes. Are these
pagetable pages accounted in part2's memblock_kernel_nodemask? It looks like
part1 and part3 of these patchsets contradict or make the goal of part2 more
difficult to achieve. (I will send more comments for part3 separately).

thanks,

- Vasilis

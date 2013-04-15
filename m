Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3DOE4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:56:37 -0400
Received: from ozlabs.org ([203.10.76.45]:49980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab3DOE4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:56:34 -0400
Date: Mon, 15 Apr 2013 14:56:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, David Howells <dhowells@redhat.com>,
        Mark Salter <msalter@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 00/19] kill free_all_bootmem() and clean up
 VALID_PAGE()
Message-ID: <20130415045614.GB7494@iris.ozlabs.ibm.com>
References: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365867399-21323-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 11:36:20PM +0800, Jiang Liu wrote:
> Commit 600cc5b7f6 "mm: Kill NO_BOOTMEM version free_all_bootmem_node()"
> has kill free_all_bootmem_node() for NO_BOOTMEM.
> 
> Currently the usage pattern for free_all_bootmem_node() is like:
> for_each_online_pgdat(pgdat)
> 	free_all_bootmem_node(pgdat);
> 
> It's equivalent to free_all_bootmem(), so this patchset goes one
> step further to kill free_all_bootmem_node() for BOOTMEM too.
> 
> This patchset also tries to clean up code and comments related to
> VALID_PAGE() because it has been removed from kernel long time ago.
> 
> Patch 1-11:
> 	Kill free_all_bootmem_node()
> Patch 12-16:
> 	Clean up code and comments related to VALID_PAGE()
> Patch 17:
> 	Fix a minor build warning for m68k
> Patch 18:
> 	merge Alpha's mem_init() for UMA and NUMA.
> Patch 19:
> 	call register_page_bootmem_info_node() from mm core

How does this not break bisection?  Will a kernel still boot with
patches 1-11 applied but not patch 19?  As far as I can see such a
kernel would have no memory available to it after mem_init() time
and would therefore crash early in boot.

Paul.


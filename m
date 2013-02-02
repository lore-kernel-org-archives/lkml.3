Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3BBAj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:39:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab3BBAjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:39:25 -0500
Date: Fri, 1 Feb 2013 16:39:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, David Hansen <dave@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jiang Liu <liuj97@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Wu Jianguo <wujianguo@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/9] mm: zone & pgdat accessors plus some cleanup
Message-Id: <20130201163924.75edfe40.akpm@linux-foundation.org>
In-Reply-To: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1358463181-17956-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013 14:52:52 -0800
Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> Summaries:
> 1 - avoid repeating checks for section in page flags by adding a define.
> 2 - add & switch to zone_end_pfn() and zone_spans_pfn()
> 3 - adds zone_is_initialized() & zone_is_empty()
> 4 - adds a VM_BUG using zone_is_initialized() in __free_one_page()
> 5 - add pgdat_end_pfn() and pgdat_is_empty()
> 6 - add debugging message to VM_BUG check.
> 7 - add ensure_zone_is_initialized() (for memory_hotplug)
> 8 - use the above addition in memory_hotplug
> 9 - use pgdat_end_pfn()

Well that's a nice little patchset.

Some of the patches were marked From:cody@linux.vnet.ibm.com and others
were From:jmesmon@gmail.com.  This is strange.  If you want me to fix
that up, please let me know which is preferred.

> As a general concern: spanned_pages & start_pfn (in pgdat & zone) are supposed
> to be locked (via a seqlock) when read (due to changes to them via
> memory_hotplug), but very few (only 1?) of their users appear to actually lock
> them.

OK, thanks.  Perhaps this is something which the memory-hotplug
developers could take a look at?


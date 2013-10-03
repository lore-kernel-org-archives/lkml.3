Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3JCUmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:42:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab3JCUmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:42:05 -0400
Date: Thu, 3 Oct 2013 13:42:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, isimatu.yasuaki@jp.fujitsu.com,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] mm/sparsemem: Fix a bug in free_map_bootmem when
 CONFIG_SPARSEMEM_VMEMMAP
Message-Id: <20131003134204.e408977b42cb85984473cfd6@linux-foundation.org>
In-Reply-To: <524CE532.1030001@gmail.com>
References: <524CE4C1.8060508@gmail.com>
	<524CE532.1030001@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Oct 2013 11:32:02 +0800 Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> We pass the number of pages which hold page structs of a memory
> section to function free_map_bootmem. This is right when
> !CONFIG_SPARSEMEM_VMEMMAP but wrong when CONFIG_SPARSEMEM_VMEMMAP.
> When CONFIG_SPARSEMEM_VMEMMAP, we should pass the number of pages
> of a memory section to free_map_bootmem.
> 
> So the fix is removing the nr_pages parameter. When
> CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
> PAGES_PER_SECTION in free_map_bootmem. When !CONFIG_SPARSEMEM_VMEMMAP,
> we calculate page numbers needed to hold the page structs for a
> memory section and use the value in free_map_bootmem.

What were the runtime user-visible effects of that bug?

Please always include this information when fixing a bug.

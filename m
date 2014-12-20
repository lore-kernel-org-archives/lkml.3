Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaLTQlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 11:41:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:45894 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbaLTQlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 11:41:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,613,1413270000"; 
   d="scan'208";a="657722784"
Message-ID: <5495A698.4050707@linux.intel.com>
Date: Sat, 20 Dec 2014 08:40:56 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, oleg@redhat.com, rientjes@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com>
In-Reply-To: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2014 05:54 AM, Rafael Aquini wrote:
> This patch introduces 'pagesize' line element to /proc/<pid>/numa_maps
> report file in order to help disambiguating the size of pages that are
> backing memory areas mapped by a task. When the VMA backing page size
> is observed different from kernel's default PAGE_SIZE, the new element 
> is printed out to complement report output. This is specially useful to
> help differentiating between HUGE and GIGANTIC page VMAs.

Heh, I completely forgot about this.  Thanks for picking it back up.

I sometimes wonder what 'numa_maps' purpose is any if we should have
_some_ kind of policy about what goes in there vs. smaps.  numa_maps
seems to be turning in to smaps, minus the \n. :)

But that isn't the case for this patch.  The "anon=50 dirty=50 N0=50"
output of numa_maps is wholly *useless* without either this patch or
some other mechanism to find out of hugetbfs memory is present.  I think
that needs to make it in to the description.

I'm fine with the code, though.  Feel free to add my acked-by.

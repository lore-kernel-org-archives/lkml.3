Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbaDHHOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:14:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:55315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaDHHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:14:51 -0400
Date: Tue, 8 Apr 2014 09:14:43 +0200
From: Andres Freund <andres@2ndquadrant.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
Message-ID: <20140408071443.GQ4161@awork2.anarazel.de>
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>
 <1396910068-11637-2-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396910068-11637-2-git-send-email-mgorman@suse.de>
X-Provags-ID: V02:K0:ukBdsTxA/Y/+VkRDXQ4RLVJZIKyk02ikFdMqNz2rbP5
 lowcK9eOrJ6GMK6m75n7Hgm1mXczs4MibWItrNzspraCTILe6p
 EXpwWM6R1ymuBhY7uePo1mOuBHc7RP0MNJvf5V81gX+hZ7TWXE
 T2IC/RmnUSYJhWflHxPxRawK/QEwsc/102v/EBj8pcaL54O2mc
 C/qiQm0ZJmjsiOQUxUZp8CtS+kg7355Bc2iBLWpQ4mMhS8QcF7
 x5u2RrhYl2+oijUV2lus6xqLvx1Kdfp++cf7th1kDJUnR9zhh9
 r3jcoIGWilzVJAqW4ZV+aJlzYSK6pTFfJE3qMxaOMATNuXe6LR
 Y5SvhVZ6G7O52Oddn91Hq62RRz6bRXZm0w4wYHxUs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2014-04-07 23:34:27 +0100, Mel Gorman wrote:
> zone_reclaim_mode causes processes to prefer reclaiming memory from local
> node instead of spilling over to other nodes. This made sense initially when
> NUMA machines were almost exclusively HPC and the workload was partitioned
> into nodes. The NUMA penalties were sufficiently high to justify reclaiming
> the memory. On current machines and workloads it is often the case that
> zone_reclaim_mode destroys performance but not all users know how to detect
> this. Favour the common case and disable it by default. Users that are
> sophisticated enough to know they need zone_reclaim_mode will detect it.

Unsurprisingly I am in favor of this.

>  Documentation/sysctl/vm.txt | 17 +++++++++--------
>  mm/page_alloc.c             |  2 --
>  2 files changed, 9 insertions(+), 10 deletions(-)

But I think linux/topology.h's comment about RECLAIM_DISTANCE should be
adapted as well.

Thanks,

Andres

-- 
 Andres Freund	                   http://www.2ndQuadrant.com/
 PostgreSQL Development, 24x7 Support, Training & Services

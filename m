Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbaGXR7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 13:59:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:12745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759681AbaGXR7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 13:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,725,1400050800"; 
   d="scan'208";a="548555615"
Message-ID: <53D14997.7090106@intel.com>
Date: Thu, 24 Jul 2014 10:59:51 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>, mingo@redhat.com,
        Yinghai Lu <yinghai@kernel.org>, mgorman@suse.de,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com
CC: wangnan0@huawei.com, Linux MM <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory-hotplug: add sysfs zone_index attribute
References: <1406187138-27911-1-git-send-email-zhenzhang.zhang@huawei.com> <53D0B8B6.8040104@huawei.com>
In-Reply-To: <53D0B8B6.8040104@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 12:41 AM, Zhang Zhen wrote:
> Currently memory-hotplug has two limits:
> 1. If the memory block is in ZONE_NORMAL, you can change it to
> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
> 2. If the memory block is in ZONE_MOVABLE, you can change it to
> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
> 
> Without this patch, we don't know which zone a memory block is in.
> So we don't know which memory block is adjacent to ZONE_MOVABLE or
> ZONE_NORMAL.
> 
> On the other hand, with this patch, we can easy to know newly added
> memory is added as ZONE_NORMAL (for powerpc, ZONE_DMA, for x86_32,
> ZONE_HIGHMEM).

A section can contain more than one zone.  This interface will lie about
such sections, which is quite unfortunate.

I'd really much rather see an interface that has a section itself
enumerate to which zones it may be changed.  The way you have it now,
any user has to know the rules that you've laid out above.  If the
kernel changed those restrictions, we'd have to teach every application
about the change in restrictions.




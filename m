Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaHRVsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 17:48:21 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42565 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaHRVsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 17:48:20 -0400
Date: Mon, 18 Aug 2014 14:48:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, toshi.kani@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        wangnan0@huawei.com, linux-kernel@vger.kernel.org,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
In-Reply-To: <53EAE534.8030303@huawei.com>
Message-ID: <alpine.DEB.2.02.1408181447260.4796@chino.kir.corp.google.com>
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com> <53EAE534.8030303@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Zhang Zhen wrote:

> Currently memory-hotplug has two limits:
> 1. If the memory block is in ZONE_NORMAL, you can change it to
> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
> 2. If the memory block is in ZONE_MOVABLE, you can change it to
> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
> 
> With this patch, we can easy to know a memory block can be onlined to
> which zone, and don't need to know the above two limits.
> 
> Updated the related Documentation.
> 
> Change v1 -> v2:
> - optimize the implementation following Dave Hansen's suggestion
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

linux-next build failure:

drivers/built-in.o: In function `show_zones_online_to':
memory.c:(.text+0x13ee09): undefined reference to `test_pages_in_a_zone'

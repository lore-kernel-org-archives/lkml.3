Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaHOVru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:47:50 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:46410 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHOVrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:47:49 -0400
Message-ID: <1408138647.26567.42.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
From: Toshi Kani <toshi.kani@hp.com>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, isimatu.yasuaki@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, wangnan0@huawei.com,
        linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>
Date: Fri, 15 Aug 2014 15:37:27 -0600
In-Reply-To: <53EAE534.8030303@huawei.com>
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com>
	 <53EAE534.8030303@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-13 at 12:10 +0800, Zhang Zhen wrote:
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
> ---
>  Documentation/ABI/testing/sysfs-devices-memory |  8 ++++
>  Documentation/memory-hotplug.txt               |  4 +-
>  drivers/base/memory.c                          | 62 ++++++++++++++++++++++++++
>  include/linux/memory_hotplug.h                 |  1 +
>  mm/memory_hotplug.c                            |  2 +-
>  5 files changed, 75 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
> index 7405de2..2b2a1d7 100644
> --- a/Documentation/ABI/testing/sysfs-devices-memory
> +++ b/Documentation/ABI/testing/sysfs-devices-memory
> @@ -61,6 +61,14 @@ Users:		hotplug memory remove tools
>  		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
> 
> 
> +What:           /sys/devices/system/memory/memoryX/zones_online_to

I think this name is a bit confusing.  How about "valid_online_types"?

Thanks,
-Toshi




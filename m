Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbaJVTQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:16:01 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:32093 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbaJVTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:15:59 -0400
Message-ID: <1414004531.12798.27.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] memory-hotplug: Clear pgdat which is allocated by
 bootmem in try_offline_node()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, zhenzhang.zhang@huawei.com,
        wangnan0@huawei.com, tangchen@cn.fujitsu.com, dave.hansen@intel.com,
        rientjes@google.com
Date: Wed, 22 Oct 2014 13:02:11 -0600
In-Reply-To: <54476215.3010006@jp.fujitsu.com>
References: <54476215.3010006@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 16:51 +0900, Yasuaki Ishimatsu wrote:
> When hot adding the same memory after hot removing a memory,
> the following messages are shown:
> 
> WARNING: CPU: 20 PID: 6 at mm/page_alloc.c:4968 free_area_init_node+0x3fe/0x426()
> ...
> Call Trace:
>  [<...>] dump_stack+0x46/0x58
>  [<...>] warn_slowpath_common+0x81/0xa0
>  [<...>] warn_slowpath_null+0x1a/0x20
>  [<...>] free_area_init_node+0x3fe/0x426
>  [<...>] ? up+0x32/0x50
>  [<...>] hotadd_new_pgdat+0x90/0x110
>  [<...>] add_memory+0xd4/0x200
>  [<...>] acpi_memory_device_add+0x1aa/0x289
>  [<...>] acpi_bus_attach+0xfd/0x204
>  [<...>] ? device_register+0x1e/0x30
>  [<...>] acpi_bus_attach+0x178/0x204
>  [<...>] acpi_bus_scan+0x6a/0x90
>  [<...>] ? acpi_bus_get_status+0x2d/0x5f
>  [<...>] acpi_device_hotplug+0xe8/0x418
>  [<...>] acpi_hotplug_work_fn+0x1f/0x2b
>  [<...>] process_one_work+0x14e/0x3f0
>  [<...>] worker_thread+0x11b/0x510
>  [<...>] ? rescuer_thread+0x350/0x350
>  [<...>] kthread+0xe1/0x100
>  [<...>] ? kthread_create_on_node+0x1b0/0x1b0
>  [<...>] ret_from_fork+0x7c/0xb0
>  [<...>] ? kthread_create_on_node+0x1b0/0x1b0
> 
> The detaled explanation is as follows:
> 
> When hot removing memory, pgdat is set to 0 in try_offline_node().
> But if the pgdat is allocated by bootmem allocator, the clearing
> step is skipped. And when hot adding the same memory, the uninitialized
> pgdat is reused. But free_area_init_node() checks wether pgdat is set
> to zero. As a result, free_area_init_node() hits WARN_ON().
> 
> This patch clears pgdat which is allocated by bootmem allocator
> in try_offline_node().
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks for the update. It looks good.

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

-Toshi




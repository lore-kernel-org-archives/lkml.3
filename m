Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3JKQfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:35:00 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:4896 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758312Ab3JKQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:34:59 -0400
Message-ID: <1381509080.26234.32.camel@misato.fc.hp.com>
Subject: Re: [PATCH] Release device_hotplug_lock when store_mem_state
 returns EINVAL
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org
Date: Fri, 11 Oct 2013 10:31:20 -0600
In-Reply-To: <52579C69.1080304@jp.fujitsu.com>
References: <52579C69.1080304@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 15:36 +0900, Yasuaki Ishimatsu wrote:
> When inserting a wrong value to /sys/devices/system/memory/memoryX/state file,
> following messages are shown. And device_hotplug_lock is never released.
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> 3.12.0-rc4-debug+ #3 Tainted: G        W
> ------------------------------------------------
> bash/6442 is leaving the kernel with locks still held!
> 1 lock held by bash/6442:
>  #0:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff8146cbb5>] lock_device_hotplug_sysfs+0x15/0x50
> 
> This issue was introdued by commit fa2be40 (drivers: base: use standard
> device online/offline for state change).
> 
> This patch releases device_hotplug_lcok when store_mem_state returns EINVAL.
> 
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> CC: Toshi Kani <toshi.kani@hp.com>
> CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Good catch!

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

